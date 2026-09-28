import '../../../anymex_extension_runtime_bridge.dart';
import '../Eval/dart/model/m_source.dart' as m;
import '../Util/string_extensions.dart';

class MSource extends Source {
  String? sourceCode;

  String? sourceCodeUrl;

  String? headers;

  SourceCodeLanguage sourceCodeLanguage = SourceCodeLanguage.dart;

  // Passed to the extension as `source.*` (see [toMSource]). API sources
  // build every request from [apiUrl] (MangaDex, Comick) and Madara sources
  // parse chapter dates with [dateFormat]; without them they fail with
  // "relative URL without a base" or a null error.
  String? apiUrl;

  String? dateFormat;

  String? dateFormatLocale;

  String? additionalParams;

  String? notes;

  bool? hasCloudflare;

  bool? isFullData;

  MSource({
    super.id,
    super.name,
    super.baseUrl,
    super.lang,
    super.isNsfw,
    super.iconUrl,
    super.version,
    super.versionLast,
    super.itemType,
    super.repo,
    super.hasUpdate,
    super.supportsLatest = false,
    super.supportsPopular = false,
    this.sourceCodeUrl,
    this.sourceCode,
    this.headers,
    this.sourceCodeLanguage = SourceCodeLanguage.dart,
    this.apiUrl,
    this.dateFormat,
    this.dateFormatLocale,
    this.additionalParams,
    this.notes,
    this.hasCloudflare,
    this.isFullData,
  });

  factory MSource.fromJson(Map<String, dynamic> json) {
    final base = Source.fromJson(json);

    final isLnReader = json['site'] != null && json['url'] != null && json['sourceCodeLanguage'] == null;

    return MSource(
      id: base.id,
      name: base.name,
      baseUrl: base.baseUrl,
      lang: base.lang,
      isNsfw: base.isNsfw,
      iconUrl: base.iconUrl,
      version: base.version,
      versionLast: base.versionLast,
      itemType: base.itemType,
      repo: base.repo,
      hasUpdate: base.hasUpdate,
      supportsLatest: base.supportsLatest ?? false,
      supportsPopular: base.supportsPopular ?? false,
      sourceCode: json['sourceCode'],
      sourceCodeUrl: json['sourceCodeUrl'] ?? json['url'],
      headers: json['headers'],
      sourceCodeLanguage: isLnReader
          ? SourceCodeLanguage.lnreader
          : SourceCodeLanguage.values[json['sourceCodeLanguage'] ?? 0],
      apiUrl: _string(json['apiUrl']),
      dateFormat: _string(json['dateFormat']),
      dateFormatLocale: _string(json['dateFormatLocale']),
      additionalParams: _string(json['additionalParams']),
      notes: _string(json['notes']),
      hasCloudflare: json['hasCloudflare'] is bool ? json['hasCloudflare'] : null,
      isFullData: json['isFullData'] is bool ? json['isFullData'] : null,
    );
  }

  static String? _string(dynamic value) => value?.toString();

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['sourceCode'] = sourceCode;
    json['sourceCodeUrl'] = sourceCodeUrl;
    json['headers'] = headers;
    json['sourceCodeLanguage'] = sourceCodeLanguage.index;
    json['apiUrl'] = apiUrl;
    json['dateFormat'] = dateFormat;
    json['dateFormatLocale'] = dateFormatLocale;
    json['additionalParams'] = additionalParams;
    json['notes'] = notes;
    json['hasCloudflare'] = hasCloudflare;
    json['isFullData'] = isFullData;
    return json;
  }

  /// Fills the fields a source installed by an older version didn't save,
  /// from its repo entry. Returns whether anything changed.
  bool fillMissingFrom(MSource repo) {
    var changed = false;
    T? take<T>(T? mine, T? theirs) {
      if (mine != null || theirs == null) return mine;
      changed = true;
      return theirs;
    }

    apiUrl = take(apiUrl, repo.apiUrl);
    dateFormat = take(dateFormat, repo.dateFormat);
    dateFormatLocale = take(dateFormatLocale, repo.dateFormatLocale);
    additionalParams = take(additionalParams, repo.additionalParams);
    notes = take(notes, repo.notes);
    hasCloudflare = take(hasCloudflare, repo.hasCloudflare);
    isFullData = take(isFullData, repo.isFullData);
    return changed;
  }

  // bool get isTorrent => (typeSource?.toLowerCase() ?? "") == "torrent";

  m.MSource toMSource() {
    return m.MSource(
      id: id?.toNullInt() ?? 0,
      name: name,
      hasCloudflare: hasCloudflare ?? false,
      isFullData: isFullData ?? true,
      lang: lang,
      baseUrl: baseUrl,
      apiUrl: apiUrl,
      dateFormat: dateFormat,
      dateFormatLocale: dateFormatLocale,
      additionalParams: additionalParams,
      notes: notes,
    );
  }
}

enum SourceCodeLanguage { dart, javascript, lnreader }
