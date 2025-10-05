import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String? realname;
  final String? firstname;
  final String? email;
  final String? phone;
  final String? mobile;
  final int? locationsId;
  final int? usertitlesId;
  final int? usercategoriesId;
  final bool isActive;
  final String? comment;
  final String? language;
  final String? dateFormat;
  final String? numberFormat;
  final String? namesFormat;
  final String? csvDelimiter;
  final bool useFlatDropdowntree;
  final bool showCountOnTabs;
  final bool refreshTicketsList;
  final bool setDefaultTech;
  final bool setDefaultRequester;
  final bool priorityAsIcon;
  final bool taskState;
  final bool foldMenu;
  final bool foldSearch;
  final bool savedSearchesPinned;
  final String? timezone;
  final String? dateMod;
  final String? lastLogin;
  final String? dateCreation;
  final String? authsId;
  final String? authtype;
  final String? userDn;
  final String? registrationNumber;
  final String? picture;

  const User({
    required this.id,
    required this.name,
    this.realname,
    this.firstname,
    this.email,
    this.phone,
    this.mobile,
    this.locationsId,
    this.usertitlesId,
    this.usercategoriesId,
    this.isActive = true,
    this.comment,
    this.language,
    this.dateFormat,
    this.numberFormat,
    this.namesFormat,
    this.csvDelimiter,
    this.useFlatDropdowntree = false,
    this.showCountOnTabs = false,
    this.refreshTicketsList = false,
    this.setDefaultTech = false,
    this.setDefaultRequester = false,
    this.priorityAsIcon = false,
    this.taskState = false,
    this.foldMenu = false,
    this.foldSearch = false,
    this.savedSearchesPinned = false,
    this.timezone,
    this.dateMod,
    this.lastLogin,
    this.dateCreation,
    this.authsId,
    this.authtype,
    this.userDn,
    this.registrationNumber,
    this.picture,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        realname,
        firstname,
        email,
        phone,
        mobile,
        locationsId,
        usertitlesId,
        usercategoriesId,
        isActive,
        comment,
        language,
        dateFormat,
        numberFormat,
        namesFormat,
        csvDelimiter,
        useFlatDropdowntree,
        showCountOnTabs,
        refreshTicketsList,
        setDefaultTech,
        setDefaultRequester,
        priorityAsIcon,
        taskState,
        foldMenu,
        foldSearch,
        savedSearchesPinned,
        timezone,
        dateMod,
        lastLogin,
        dateCreation,
        authsId,
        authtype,
        userDn,
        registrationNumber,
        picture,
      ];

  String get displayName {
    if (realname != null && firstname != null) {
      return '$firstname $realname';
    } else if (realname != null) {
      return realname!;
    } else {
      return name;
    }
  }

  String get initials {
    if (firstname != null && realname != null) {
      return '${firstname![0]}${realname![0]}'.toUpperCase();
    } else if (realname != null) {
      return realname![0].toUpperCase();
    } else {
      return name[0].toUpperCase();
    }
  }

  User copyWith({
    int? id,
    String? name,
    String? realname,
    String? firstname,
    String? email,
    String? phone,
    String? mobile,
    int? locationsId,
    int? usertitlesId,
    int? usercategoriesId,
    bool? isActive,
    String? comment,
    String? language,
    String? dateFormat,
    String? numberFormat,
    String? namesFormat,
    String? csvDelimiter,
    bool? useFlatDropdowntree,
    bool? showCountOnTabs,
    bool? refreshTicketsList,
    bool? setDefaultTech,
    bool? setDefaultRequester,
    bool? priorityAsIcon,
    bool? taskState,
    bool? foldMenu,
    bool? foldSearch,
    bool? savedSearchesPinned,
    String? timezone,
    String? dateMod,
    String? lastLogin,
    String? dateCreation,
    String? authsId,
    String? authtype,
    String? userDn,
    String? registrationNumber,
    String? picture,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      realname: realname ?? this.realname,
      firstname: firstname ?? this.firstname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      mobile: mobile ?? this.mobile,
      locationsId: locationsId ?? this.locationsId,
      usertitlesId: usertitlesId ?? this.usertitlesId,
      usercategoriesId: usercategoriesId ?? this.usercategoriesId,
      isActive: isActive ?? this.isActive,
      comment: comment ?? this.comment,
      language: language ?? this.language,
      dateFormat: dateFormat ?? this.dateFormat,
      numberFormat: numberFormat ?? this.numberFormat,
      namesFormat: namesFormat ?? this.namesFormat,
      csvDelimiter: csvDelimiter ?? this.csvDelimiter,
      useFlatDropdowntree: useFlatDropdowntree ?? this.useFlatDropdowntree,
      showCountOnTabs: showCountOnTabs ?? this.showCountOnTabs,
      refreshTicketsList: refreshTicketsList ?? this.refreshTicketsList,
      setDefaultTech: setDefaultTech ?? this.setDefaultTech,
      setDefaultRequester: setDefaultRequester ?? this.setDefaultRequester,
      priorityAsIcon: priorityAsIcon ?? this.priorityAsIcon,
      taskState: taskState ?? this.taskState,
      foldMenu: foldMenu ?? this.foldMenu,
      foldSearch: foldSearch ?? this.foldSearch,
      savedSearchesPinned: savedSearchesPinned ?? this.savedSearchesPinned,
      timezone: timezone ?? this.timezone,
      dateMod: dateMod ?? this.dateMod,
      lastLogin: lastLogin ?? this.lastLogin,
      dateCreation: dateCreation ?? this.dateCreation,
      authsId: authsId ?? this.authsId,
      authtype: authtype ?? this.authtype,
      userDn: userDn ?? this.userDn,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      picture: picture ?? this.picture,
    );
  }
}