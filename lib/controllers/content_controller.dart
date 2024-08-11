import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:living_way/constants/content.dart' as content;
import 'package:living_way/models/activity_content.dart';
import 'package:living_way/models/book.dart';
import 'package:living_way/models/thread.dart';
import 'package:living_way/models/translation.dart';
import 'package:living_way/utils/load_json.dart';

class ContentController extends ChangeNotifier {
  final TextEditingController commentBoxTextEditingController =
      TextEditingController();
  ActivityFilter topicActivityFilter = ActivityFilter.latest;
  ActivityFilter threadActivityFilter = ActivityFilter.latest;
  CategoryFilter categoryFilter = CategoryFilter.all;
  List<String> booksFiltered = [];
  List<ThreadData> threads = content.threads;
  ValueNotifier<GlobalKey?> commentingThreadKeyNotifier = ValueNotifier(null);
  List<Book> bible = [];
  List<Translation> translations = [
    Translation(name: "KJV", isAvailabe: true),
    Translation(name: "NKJV", downloadUrl: ""),
    Translation(name: "ASV"),
    Translation(name: "NASB")
  ];
  List<ActivityContent> activityList = [
    ActivityContent(
        id: '1',
        isOngoing: true,
        type: ContentType.event,
        timestamp: DateTime.now().subtract(const Duration(days: 1))),
    ActivityContent(
        id: '2',
        type: ContentType.article,
        title: "ቤተክርስቲያን አልባ አማኞች",
        banner: ContentBanner(position: "", thumbnail: "", url: "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2Fimage_2022_02_15_15_54_05_dab102c7e1.png&w=1920&q=75"),
        body: "የኮቪድ ወረርሽኝ በተባባሰበት እና የቤተክርስቲያን መሰባሰብ ላይ ገደብ በተጣለ ወቅት፣ አብዛኛውን አማኝ “ቤተክርስቲያን መሄድ ናፈቀኝ” እያለ ሲናገር የቅርብ ጊዜ ትውስታችን ነው፡፡",
        content: [
          "የኮቪድ ወረርሽኝ በተባባሰበት እና የቤተክርስቲያን መሰባሰብ ላይ ገደብ በተጣለ ወቅት፣ አብዛኛውን አማኝ “ቤተክርስቲያን መሄድ ናፈቀኝ” እያለ ሲናገር የቅርብ ጊዜ ትውስታችን ነው፡፡ እውነት ነው ቤተክርስቲያን፣ የቅዱሳን ሕብረት እጅጉን ይናፍቃል፡፡ ነገር ግን የአንዳንዶቻችንን ናፍቆት የፈጠረው ገደቡ ይመስል ነበር፡፡ ለምን? ትላንትና በሰላሙ ቀን ቤተክርስቲያን ለመሄድ ብዙ አቃቂር የምናወጣ ነበርን፡፡ ልክ ከእጃችን ስናጣው ምን ያህል አስፈላጊ እንደሆነ በጥቂቱ ያየንበት አጋጣሚ ነው፡፡ እውነት ነው፣ ቤተክርስቲያን እስከብዙ ጉድለቷ እጅጉ አስፈላጊ የክርስቶስ አካል ናት፡፡",
          "ዛሬ በዚህች አጭር ጹሁፍ ልንዳስስ የምንፈልገው ከቅርብ ጊዜ ወዲህ አባል የሆኑበት ቤተክርስቲያን ስሌላቸው እና እየጨመሩ ስለመጡ ምዕመናን ነው፡፡ አሁን አሁን በአማኙ በተለይ በወጣቱ ዘንድ የቋንቋ ለውጥ አለ፡፡ ድሮ ድሮ የየት ቤተክርስቲያን አባል ነህ ነበር የሚባለው፣ ዛሬ ዛሬ ግን “ቸርች የት ነው የምትካፈለው?” ወይም አንዳንዶች ሲመልሱ “ቸርች የምካፈለው እዚህ…ነው” ይላሉ፡፡ ይህ በሌጣው ምንም ክፋት የሌለበት ቢመስልም፣ የአንድ ቤተክርስቲያን አባል የመሆንን እሴት እየሸረሸረ ነው፡፡ ሰዎች ሰንበትን ጠብቀው ደስ ያለቸው ቦታ ሄደው ይካፈላሉ፡፡ ከዚያ ያለፈ ነገር አያስፈልግም የሚል አንድምታ አለው፡፡",
          "ግን ለምን ቤተክርስቲያን አልባ ምዕመን በዛ? መቼም ይሄ ሰፊ ትንተና ቢፈልግም፣ እንዲሁ ዋና ዋናዎቹን እንመልከት፡፡ እነዚህን ቤተክርስቲያን አልባ ምዕመኖችን በሁለት ከፍለን እንመልከት፡፡ የመጀመሪያዎቹ፣ ወደው ሳይሆን ተገደው (ሙሉ ለሙሉ ልክ ናቸው እያልን አይደለም) ተንሳፋፊ ምዕመን የሆኑ አሉ፡፡ እነዚህ ሰዎች በቤተክርስቲያን መሪዎች፣ አገልጋዮች ተገፍተው እና ተጎድተው ጥጋቸውን የያዙ፣ ተመልሰው ወደቤተክርስቲያን ለመግባት እምነታቸውን ያጡ ናቸው፡፡ አንዳንዶቹም በተለይ አሁን ባለው የኢትዮጲያ ነባራዊ ሁኔታ፣ ከቅርብ ጊዜ ወደዚህ በተተከሉ ቤተክርስቲያኖች ለመገልገል ሄደው፣ ከቀን ወደቀን ያፈነገጡ አስተምህሮዎች፣ ልምምዶች እና የአማራር አካሄዶች ሲያዩና ነገሩ አልጥም ሲላቸው ከዚያ ቦታ ነቅለው ተንሳፋፊ የሆኑም ብዙ ናቸው፡፡ መቼም ከእነዚህ አንዳንዶቹን ቀርበን ስንመለከት፣ በጣም ለቤተክርስቲያን ሊጠቅሙ የሚችሉ እና የነገ ተተኪ ትውልድ ተስፋዎች ነበሩ፤ እውነተኞች ስለሆኑ እና ነገርን ለማደባበስ ስለማይችሉ ብቻ በአሻጥር ከጨዋታው ውጪ የተደረጉ ናቸው፡፡",
          "ሁለተኞቹ፣ ከንቱ ዘመናዊነት ያጠቃቸው፣ ምንም አይነት ኋላፊነት መውሰድ የማይፈልጉ፣ በገዛ ፈቃዳቸው መኖር የሚፈልጉ፣ እንደው ትዝ ሲላቸው ያሰኛቸው ቦታ ብቅ ብለው፣ ወይ የውስጥ ባዶነታቸውን እና ወቀሳቸውን ትንሽ አስታመው ለመውጣት የሚሄዱ ናቸው፡፡ ቀርቦ እነዚህን ሰዎች ለተመለከተ ሰው፣ እግዚአብሔር የመለኪያ ቱንቢውን የሰጣቸው የጥራት እና ደረጃ መዳቢዎች ነው የሚመስሉት፡፡",
          "ብቻ በዚህም ይሁን በዚያ፣ ይህ ምን ያህል መጽሐፍ ቅዱሳዊ ነው? ምን ያህልስ አዋጭ ነው? አባልነትስ ለምን ይህን ያህል ተፈራ? ብለን መጠየቅ አለብን፡፡ ሲ. ኤስ ሊዊስ አንድ ጊዜ ስለቤተክርስቲያን አባልነት ሲናገር፣ ቃሉ ክርስቲያናዊ ስር መሰረት ቢኖረውም፣ ነገር ግን አለም ወስዳው ትክክለኛውን ትረጉሙን ባዶ አድርጋዋለች ብሏል፡፡ ዛሬ ዛሬ፣ ሰዎች ይህንን ቃል ግዴታን ከመክፈል፣ ከትርጉም የለሽ ስርዓቶች፣ ተራ መመሪያዎች እና ሕጎች፣ ሞኛ ሞኝ ከሆኑ ሰዎች ጋር መሰባሰብ እና ሰላምታ ጋር ያይዙታል፡፡",
          "እንዲሁም ኤድ ሰቴትዘር በአንድ ጹሁፉ እንደሚናገረው፣ ብዙዎች አባልነትን ሲያስቡ የሚመጣላቸው አንድ ቡድን ወይም ክለብ ውስጥ መካተት ይመስላቸዋል፡፡ ነገር ግን መጽሐፍ ቅዱስ ስለአባልነት ይህንን አይናገርም፤ ጳውሎስ በ1ኛ ቆሮንጦስ ቤተክርስቲያን አካል እንደሆነች ይነግረናል፡፡ የእያንዳንዳችንን ግንኙነት ደግሞ ሲናገር፣ የዚህ አካል አባላት እንደሆንን ይገልፃል፡፡ በመጽሐፍ ቅዱስ “አባል” የሚለው ቃል በተለምዶ ከምንጠቀምበት አጠቃቀም ይልቅ፣ በሕክምናው ያለው አጠቃቀም በደንብ ለመረዳት ይረዳናል፡፡ ለምሳሌ፡- በሆነ አደጋ ወይም አጋጣሚ አንድ ጣታችሁን ብታጡ፣ በዚያች ዕደለቢስ ቀን አካለጎዶሎ/ በቀጥታ ሲተረጎም አባለጎዶሎ (dismembered) ሆናችሁ፡፡ ይህ ትክክለኛው የቴክኒካዊ አጠራር ነው፡፡ የአካላችሁ አባል ከአካላችሁ ተለየ እንደማለት ነው፡፡ በጣምም አሳዛኝ ወይም አስደንጋጭ ነገር ነው፡፡ አሁን አሁን ግን ከአማኞች ህብረት/አካል (body of believers) መለየት ብዙም የማይደንቅ በጣም የተለመደ፣ እንደውም ብዙ ሰባኪዎች እና በየመድረኩ የምንመለከታቸው ዘማሪዎችም የሚያደርጉት ነገር ነው፡፡",
          "ነገር ግን ከዚህ አካል መለየት ምን ያህል ከባድ እንደሆነ ለመረዳት፣ በመጀመሪያዋ ቤተክርስቲያን ሰዎች ከዚህ አካል ውጪ ሲደረጉ ትለቁ ቅጣት እንደነበር ማስታወስ ጥሩ ነው፡፡ ዛሬ ግን እኛ በራሳችን ላይ በፈቃደኝነት ያስተላለፍነው ትልቅ ቅጣት ነው፡፡የአንዳንዶቻችን ሕይወት ከዕለት ዕለት እያሽቆለቆለ፣ ሕይወትን ያለማን አለብኝነት እየመራን እንገኛለን፡፡ ምናልባት አንዳንዶች በግል በርትተው ይሆናል፣ ይህ ግን ማለት የቅዱሳንን ሕብረት ይተካል ማለት አይደለም፡፡ ማንም ብቻውን የሚሰራ የለም፣ ሕይወት በመስተጋብርም ጭምር የምትሰራ እንጂ! ደግሞስ እግዚአብሔር የሰጠንስ ፀጋ፣ እንዲሁ በከንቱ ለምን ይባክናል፡፡ የተሰጠን በክርስቶስ አካል ውስጥ ለቅዱሳን መታነጽ እና ለአካሉ መገንባትም መሆኑን አንርሳ፡፡",
          "ሰቴትዘር ይህንን እንዲህ ይገልፀዋል፣ ሰዎች ከክርስቲያን ማህበረሰብ ጋር ለመቆራኝት/ለመያያዝ የቤተክርስቲያን አባልነት ያስፈልጋቸዋል፡፡ ይሄ ለአማኙ ማህበረሰብ ብቻ ሳይሆን፣ ለግለሰቡም ጭምር ሲባል ነው፡፡ የግለኝነት ክርስትና ቅዠት እና ጎጂ ፍላጎት ነው፡፡ ቃሉ እንደሚነግረን ተዋጀተናል ደግሞም በአካሉ ውስጥ ተደርገናል፡፡ የተዋጀነውም ከእግዚአብሔር ሕዝብ ጋር አብረን እንድንሰራ ነው፡፡ አባልነት አያድንም፣ ነገር ግን በመንፈሳዊ ሕይወታችን እንድናድግ እና በክርሰቶስ እንድንበስል ይረዳናል፡፡",
          "ስለዚህ የቤተክርስቲያን ደንበኛ ሳይሆን አባል ወይም የዚህ ሕያው አካል ክፍል እንድንሆን የእግዚአብሄር ፈቃድ ነው፡፡ በእንደዚህ ሁኔታ ውስጥ ያላችሁ ወገኖች ዛሬ ትንሽ ቆም ብላችሁ አስቡበት፣ በፀሎትም ሆነ ወንድሞችን በማማከር ጤናማ አስተምህሮ እና ልምምድ ያለቸው ቤተክርስቲያን ውስጥ በአባልነት ለመያዝ ወደዚህ ውሳኔ እንድትመጡ እበረታታችኋለሁ፡፡"
        ],
        timestamp: DateTime.now().subtract(const Duration(days: 1))),
    // ActivityContent(
    //     id: '3',
    //     type: ContentType.article,
    //     timestamp: DateTime.now().subtract(const Duration(hours: 1))),
    ActivityContent(
        id: '4',
        title: "For His Glory Questionairre",
        body: "See you tomorrow at 10:00. Q&A #ለእርሱ_ክብር",
        externalLink: "https://app.sli.do/event/6T57oAJjVuyHwVXhbUunAY",
        type: ContentType.external,
        timestamp: DateTime.now().add(const Duration(hours: 1))),
    ActivityContent(
        id: '5',
        type: ContentType.gallery,
        title: "“ሕይወት ለዋጭ ወንጌል” የቲቶ መልዕክት ጥናት Week 2",
        minimumAllowedViewImages: 5,
        images: [
          "https://instagram.fadd2-1.fna.fbcdn.net/v/t51.29350-15/454445120_515389501026011_2844082436010991590_n.jpg?stp=dst-jpg_e35_s1080x1080&_nc_ht=instagram.fadd2-1.fna.fbcdn.net&_nc_cat=111&_nc_ohc=w1VBbM8gkfMQ7kNvgFAS0JR&edm=AGenrX8BAAAA&ccb=7-5&oh=00_AYC7ZZyl1MFvB6ipq4zmRYlOEwmm7DZtqQTNqCaYMsPYqA&oe=66BD48E0&_nc_sid=ed990e",
          "https://instagram.fadd1-1.fna.fbcdn.net/v/t51.29350-15/454339781_823704839502816_8805898697190177090_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgwOS5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd1-1.fna.fbcdn.net&_nc_cat=100&_nc_ohc=HgbQOvJ6ZZ8Q7kNvgEhfITc&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzAxMDg0OTg4NA%3D%3D.2-ccb7-5&oh=00_AYAVHSmMSuzWenGrPEjwPS7oawwPm4j3nkoKfDoqio-BIQ&oe=66BD5CBE&_nc_sid=8f1549",
          "https://instagram.fadd2-1.fna.fbcdn.net/v/t51.29350-15/454347125_502479292505207_2841394535742577413_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgxMC5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd2-1.fna.fbcdn.net&_nc_cat=111&_nc_ohc=ja4oDXI1Y-gQ7kNvgEOr0MA&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzAxOTEzOTg1OA%3D%3D.2-ccb7-5&oh=00_AYCrpM6npiKkGUFNWg8nNDerjfTUdAAfD8WezjmVxAdI0w&oe=66BD571D&_nc_sid=8f1549",
          "https://instagram.fadd1-1.fna.fbcdn.net/v/t51.29350-15/454355896_376052815519260_924894334783785225_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgxMC5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd1-1.fna.fbcdn.net&_nc_cat=100&_nc_ohc=JCjI-xdmtXYQ7kNvgGzaoMC&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzIxMjA4NjMzNg%3D%3D.2-ccb7-5&oh=00_AYC_JHnf-jM_m4YT0R8XKt0cf6CERquhQdbeb0xj-YRDQQ&oe=66BD4B1D&_nc_sid=8f1549",
          "https://instagram.fadd1-1.fna.fbcdn.net/v/t51.29350-15/454383853_844023010691391_7888535021732231256_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgxMC5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd1-1.fna.fbcdn.net&_nc_cat=103&_nc_ohc=1P-lqfsUXcQQ7kNvgH9zdKr&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzAyNzU5NzMzMg%3D%3D.2-ccb7-5&oh=00_AYAOy9eW-iRD3-cNo-61IXEVA-uN3mSb6uKvoDCLqlFY-w&oe=66BD2656&_nc_sid=8f1549",
          "https://instagram.fadd1-1.fna.fbcdn.net/v/t51.29350-15/454390602_1042964344159074_8526859650911907146_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgxMC5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd1-1.fna.fbcdn.net&_nc_cat=106&_nc_ohc=eBK5hKvo4wIQ7kNvgGd-f1u&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzAxOTI1ODU4Nw%3D%3D.2-ccb7-5&oh=00_AYDKSi8nsM8ypoFhyu83j6s4aPXiSWZJ9XPHBDy0Vs4DKg&oe=66BD4A15&_nc_sid=8f1549",
          "https://instagram.fadd2-1.fna.fbcdn.net/v/t51.29350-15/454626324_2402679976789943_2747565838855526354_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgxMC5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd2-1.fna.fbcdn.net&_nc_cat=111&_nc_ohc=vuy78KzeiI0Q7kNvgHBxMPW&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzAxOTE1NDAwOA%3D%3D.2-ccb7-5&oh=00_AYBPesuh2qQ5_eEOoOHEb6MFPE-boqRPngMgya0Dun7E8g&oe=66BD3313&_nc_sid=8f1549",
          "https://instagram.fadd1-1.fna.fbcdn.net/v/t51.29350-15/454386924_1223351595469970_2446944206604132944_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgxMC5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd1-1.fna.fbcdn.net&_nc_cat=102&_nc_ohc=Z6K8YNS5VbUQ7kNvgHjKSks&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzAyNzUxNzAxNQ%3D%3D.2-ccb7-5&oh=00_AYDDofiozpCWic7-HWJ-q0M67y2ZfikUp5xAcGY_l7DjWA&oe=66BD3249&_nc_sid=8f1549",
          "https://instagram.fadd2-1.fna.fbcdn.net/v/t51.29350-15/454387991_845543030855327_4041453556796890906_n.jpg?stp=dst-jpg_e35&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDgxMC5zZHIuZjI5MzUwIn0&_nc_ht=instagram.fadd2-1.fna.fbcdn.net&_nc_cat=111&_nc_ohc=xVkeMtoHT9wQ7kNvgFPIxjo&edm=AEhyXUkBAAAA&ccb=7-5&ig_cache_key=MzQyOTI4NTU5NzExOTk1NTAxNg%3D%3D.2-ccb7-5&oh=00_AYD2-s6RDequlxoTa1vKWN-AZ70kcBhlySSDVz2E5NVYCQ&oe=66BD2CAF&_nc_sid=8f1549"
        ],
        timestamp: DateTime(2024, 8, 7, 16)),
    ActivityContent(
        id: '6',
        type: ContentType.poll,
        title: 'When will you be available?',
        pollOptions: [
          PollOptions(title: '10:00 AM', votes: 28),
          PollOptions(title: '10:30 AM', votes: 8),
          PollOptions(title: '11:00 AM', votes: 40),
          PollOptions(title: '12:00 PM', votes: 100)
        ],
        timestamp: DateTime.now().add(const Duration(days: 2))),
    ActivityContent(
        id: '7',
        type: ContentType.poll,
        title: 'What shall we study?',
        pollOptions: [
          PollOptions(title: 'Daniel', votes: 28),
          PollOptions(title: 'Hosea', votes: 8),
          PollOptions(title: 'Amos', votes: 40),
          PollOptions(title: 'Micah', votes: 100)
        ],
        timestamp: DateTime.now().add(const Duration(days: 8))),
    ActivityContent(
        id: '8',
        type: ContentType.poll,
        title: "How old are you?",
        pollOptions: [
          PollOptions(title: 'less than 18', votes: 28),
          PollOptions(title: '18 - 30', votes: 8),
          PollOptions(title: '31 - 50', votes: 40),
          PollOptions(title: '51 +', votes: 100)
        ],
        timestamp: DateTime.now().add(const Duration(days: 12))),
    ActivityContent(
        id: '9',
        type: ContentType.event,
        timestamp: DateTime.now().add(const Duration(days: 720)))
  ];

  Book? book;
  int? chapter;
  int? verse;
  Translation? translation;

  ContentController() {
    loadJson('assets/data/en_kjv.json').then((data) {
      bible = (data as List)
          .map((e) => Book(
              name: e['name'],
              chapters: (e['chapters'] as List)
                  .map((chapter) => (chapter as List)
                      .map((verse) => verse.toString())
                      .toList())
                  .toList()))
          .toList();
      notifyListeners();
    });
  }

  set setActivityFilter(ActivityFilter value) {
    topicActivityFilter = value;
    notifyListeners();
  }

  set setThreadFilter(ActivityFilter value) {
    threadActivityFilter = value;
    notifyListeners();
  }

  set setCategoryFilter(CategoryFilter value) {
    categoryFilter = value;
    notifyListeners();
  }

  set setBooksFilter(List<String> books) {
    booksFiltered = books;
    notifyListeners();
  }

  set setCommentingThreadKey(GlobalKey? value) {
    commentingThreadKeyNotifier.value = value;
    notifyListeners();
  }

  set setTranslation(Translation value) {
    translation = value;
    notifyListeners();
  }

  set setBook(Book value) {
    book = value;
    notifyListeners();
  }

  set setChapter(int? value) {
    chapter = value;
    notifyListeners();
  }

  set setVerse(int? value) {
    verse = value;
    notifyListeners();
  }
}

enum ActivityFilter { mostActive, mostLiked, mostViewed, latest }

enum CategoryFilter { all, ot, nt }
