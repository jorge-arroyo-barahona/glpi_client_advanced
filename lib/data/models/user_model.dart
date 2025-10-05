import 'package:json_annotation/json_annotation.dart';
import 'package:glpi_client_advanced/domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
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
  @JsonKey(name: 'is_active')
  final int isActive;
  final String? comment;
  final String? language;
  @JsonKey(name: 'date_format')
  final String? dateFormat;
  @JsonKey(name: 'number_format')
  final String? numberFormat;
  @JsonKey(name: 'names_format')
  final String? namesFormat;
  @JsonKey(name: 'csv_delimiter')
  final String? csvDelimiter;
  @JsonKey(name: 'use_flat_dropdowntree')
  final int useFlatDropdowntree;
  @JsonKey(name: 'show_count_on_tabs')
  final int showCountOnTabs;
  @JsonKey(name: 'refresh_tickets_list')
  final int refreshTicketsList;
  @JsonKey(name: 'set_default_tech')
  final int setDefaultTech;
  @JsonKey(name: 'set_default_requester')
  final int setDefaultRequester;
  @JsonKey(name: 'priority_as_icon')
  final int priorityAsIcon;
  @JsonKey(name: 'task_state')
  final int taskState;
  @JsonKey(name: 'fold_menu')
  final int foldMenu;
  @JsonKey(name: 'fold_search')
  final int foldSearch;
  @JsonKey(name: 'savedsearches_pinned')
  final int savedSearchesPinned;
  final String? timezone;
  @JsonKey(name: 'date_mod')
  final String? dateMod;
  @JsonKey(name: 'last_login')
  final String? lastLogin;
  @JsonKey(name: 'date_creation')
  final String? dateCreation;
  @JsonKey(name: 'auths_id')
  final String? authsId;
  final String? authtype;
  @JsonKey(name: 'user_dn')
  final String? userDn;
  @JsonKey(name: 'registration_number')
  final String? registrationNumber;
  final String? picture;

  const UserModel({
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
    this.isActive = 1,
    this.comment,
    this.language,
    this.dateFormat,
    this.numberFormat,
    this.namesFormat,
    this.csvDelimiter,
    this.useFlatDropdowntree = 0,
    this.showCountOnTabs = 0,
    this.refreshTicketsList = 0,
    this.setDefaultTech = 0,
    this.setDefaultRequester = 0,
    this.priorityAsIcon = 0,
    this.taskState = 0,
    this.foldMenu = 0,
    this.foldSearch = 0,
    this.savedSearchesPinned = 0,
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

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() => User(
        id: id,
        name: name,
        realname: realname,
        firstname: firstname,
        email: email,
        phone: phone,
        mobile: mobile,
        locationsId: locationsId,
        usertitlesId: usertitlesId,
        usercategoriesId: usercategoriesId,
        isActive: isActive == 1,
        comment: comment,
        language: language,
        dateFormat: dateFormat,
        numberFormat: numberFormat,
        namesFormat: namesFormat,
        csvDelimiter: csvDelimiter,
        useFlatDropdowntree: useFlatDropdowntree == 1,
        showCountOnTabs: showCountOnTabs == 1,
        refreshTicketsList: refreshTicketsList == 1,
        setDefaultTech: setDefaultTech == 1,
        setDefaultRequester: setDefaultRequester == 1,
        priorityAsIcon: priorityAsIcon == 1,
        taskState: taskState == 1,
        foldMenu: foldMenu == 1,
        foldSearch: foldSearch == 1,
        savedSearchesPinned: savedSearchesPinned == 1,
        timezone: timezone,
        dateMod: dateMod,
        lastLogin: lastLogin,
        dateCreation: dateCreation,
        authsId: authsId,
        authtype: authtype,
        userDn: userDn,
        registrationNumber: registrationNumber,
        picture: picture,
      );

  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        name: user.name,
        realname: user.realname,
        firstname: user.firstname,
        email: user.email,
        phone: user.phone,
        mobile: user.mobile,
        locationsId: user.locationsId,
        usertitlesId: user.usertitlesId,
        usercategoriesId: user.usercategoriesId,
        isActive: user.isActive ? 1 : 0,
        comment: user.comment,
        language: user.language,
        dateFormat: user.dateFormat,
        numberFormat: user.numberFormat,
        namesFormat: user.namesFormat,
        csvDelimiter: user.csvDelimiter,
        useFlatDropdowntree: user.useFlatDropdowntree ? 1 : 0,
        showCountOnTabs: user.showCountOnTabs ? 1 : 0,
        refreshTicketsList: user.refreshTicketsList ? 1 : 0,
        setDefaultTech: user.setDefaultTech ? 1 : 0,
        setDefaultRequester: user.setDefaultRequester ? 1 : 0,
        priorityAsIcon: user.priorityAsIcon ? 1 : 0,
        taskState: user.taskState ? 1 : 0,
        foldMenu: user.foldMenu ? 1 : 0,
        foldSearch: user.foldSearch ? 1 : 0,
        savedSearchesPinned: user.savedSearchesPinned ? 1 : 0,
        timezone: user.timezone,
        dateMod: user.dateMod,
        lastLogin: user.lastLogin,
        dateCreation: user.dateCreation,
        authsId: user.authsId,
        authtype: user.authtype,
        userDn: user.userDn,
        registrationNumber: user.registrationNumber,
        picture: user.picture,
      );
}