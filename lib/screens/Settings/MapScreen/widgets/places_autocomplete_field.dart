import 'dart:async';

import 'package:flutter/material.dart';
import 'package:living_way/core/core.dart';

class PlacesAutocompleteField extends StatefulWidget {
  const PlacesAutocompleteField({
    required this.controller,
    required this.decoration,
    required this.style,
    required this.onChanged,
    required this.onPlaceSelected,
    this.focusNode,
    this.enabled = true,
    this.textInputAction,
    this.keyboardType,
    super.key,
  });

  final TextEditingController controller;
  final InputDecoration decoration;
  final TextStyle style;
  final ValueChanged<String> onChanged;
  final ValueChanged<PlaceDetails> onPlaceSelected;
  final FocusNode? focusNode;
  final bool enabled;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;

  @override
  State<PlacesAutocompleteField> createState() =>
      _PlacesAutocompleteFieldState();
}

class _PlacesAutocompleteFieldState extends State<PlacesAutocompleteField> {
  final _placesService = GooglePlacesService();

  Timer? _debounce;
  List<PlaceSuggestion> _suggestions = [];
  bool _isLoading = false;
  bool _isSelecting = false;
  String? _error;
  int _requestId = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    widget.onChanged(value);
    _debounce?.cancel();
    final requestId = ++_requestId;

    if (value.trim().length < 3) {
      setState(() {
        _suggestions = [];
        _isLoading = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      try {
        final suggestions = await _placesService.autocomplete(value.trim());
        if (!mounted || requestId != _requestId) return;
        setState(() {
          _suggestions = suggestions;
          _isLoading = false;
        });
      } catch (error) {
        if (!mounted || requestId != _requestId) return;
        setState(() {
          _suggestions = [];
          _isLoading = false;
          _error = error.toString();
        });
      }
    });
  }

  Future<void> _selectSuggestion(PlaceSuggestion suggestion) async {
    setState(() {
      _isSelecting = true;
      _error = null;
    });
    try {
      final place = await _placesService.getPlaceDetails(
        suggestion.placeId,
        fallbackAddress: suggestion.description,
      );
      if (!mounted) return;

      place.address = suggestion.description;

      widget.controller.value = TextEditingValue(
        text: place.address ?? "",
        selection: TextSelection.collapsed(offset: place.address?.length ?? 0),
      );
      widget.onPlaceSelected(place);
      setState(() {
        _suggestions = [];
        _isSelecting = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isSelecting = false;
        _error = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled && !_isSelecting,
          style: widget.style,
          decoration: widget.decoration.copyWith(
              suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoading || _isSelecting)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              if (widget.decoration.suffixIcon != null)
                widget.decoration.suffixIcon!,
              if (widget.controller.text.isNotEmpty)
                InkWell(
                    onTap: () {
                      widget.controller.clear();
                      setState(() {});
                    },
                    child: const Icon(Icons.cancel)),
              const SizedBox(width: 8),
            ],
          )),
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          onChanged: _onChanged,
        ),
        if (_suggestions.isNotEmpty)
          Material(
            elevation: 4,
            color: colors.surface,
            borderRadius: BorderRadius.circular(8),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(suggestion.description),
                  onTap: () => _selectSuggestion(suggestion),
                );
              },
            ),
          ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              Tr.t('addressSuggestionsUnavailable'),
              style: TextStyle(color: colors.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
