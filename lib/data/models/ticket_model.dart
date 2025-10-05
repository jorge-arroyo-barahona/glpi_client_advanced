import 'package:json_annotation/json_annotation.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';

part 'ticket_model.g.dart';

@JsonSerializable()
class TicketModel {
  final int id;
  final String name;
  final String? content;
  final int? status;
  final int? priority;
  final int? urgency;
  final int? impact;
  final int? type;
  final int? usersIdRecipient;
  final String? date;
  final String? dateMod;
  final int? entitiesId;
  final int? itilcategoriesId;
  final int? locationsId;
  final String? latitude;
  final String? longitude;
  final int? requesttypesId;
  final int? ticketsId;
  final int? usersIdLastUpdater;
  final String? solvedate;
  final String? closedate;
  final int? slasId;
  final int? olasId;
  final String? internalTimeToResolve;
  final String? internalTimeToOwn;
  final String? waitingDuration;
  final String? closeDelayStat;
  final String? solveDelayStat;
  final String? takeintoaccountDelayStat;
  final String? actiontime;
  final int? isDeleted;
  final String? locationsIdField;
  final String? links;
  final List<dynamic>? _usersIdAssign;
  final List<dynamic>? _usersIdRequester;
  final List<dynamic>? _usersIdObserver;
  final List<dynamic>? _groupsIdAssign;
  final List<dynamic>? _groupsIdRequester;
  final List<dynamic>? _groupsIdObserver;

  const TicketModel({
    required this.id,
    required this.name,
    this.content,
    this.status,
    this.priority,
    this.urgency,
    this.impact,
    this.type,
    this.usersIdRecipient,
    this.date,
    this.dateMod,
    this.entitiesId,
    this.itilcategoriesId,
    this.locationsId,
    this.latitude,
    this.longitude,
    this.requesttypesId,
    this.ticketsId,
    this.usersIdLastUpdater,
    this.solvedate,
    this.closedate,
    this.slasId,
    this.olasId,
    this.internalTimeToResolve,
    this.internalTimeToOwn,
    this.waitingDuration,
    this.closeDelayStat,
    this.solveDelayStat,
    this.takeintoaccountDelayStat,
    this.actiontime,
    this.isDeleted,
    this.locationsIdField,
    this.links,
    List<dynamic>? usersIdAssign,
    List<dynamic>? usersIdRequester,
    List<dynamic>? usersIdObserver,
    List<dynamic>? groupsIdAssign,
    List<dynamic>? groupsIdRequester,
    List<dynamic>? groupsIdObserver,
  })  : _usersIdAssign = usersIdAssign,
        _usersIdRequester = usersIdRequester,
        _usersIdObserver = usersIdObserver,
        _groupsIdAssign = groupsIdAssign,
        _groupsIdRequester = groupsIdRequester,
        _groupsIdObserver = groupsIdObserver;

  factory TicketModel.fromJson(Map<String, dynamic> json) =>
      _$TicketModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicketModelToJson(this);

  List<dynamic>? get usersIdAssign => _usersIdAssign;
  List<dynamic>? get usersIdRequester => _usersIdRequester;
  List<dynamic>? get usersIdObserver => _usersIdObserver;
  List<dynamic>? get groupsIdAssign => _groupsIdAssign;
  List<dynamic>? get groupsIdRequester => _groupsIdRequester;
  List<dynamic>? get groupsIdObserver => _groupsIdObserver;

  Ticket toEntity() => Ticket(
        id: id,
        name: name,
        content: content,
        status: status != null ? TicketStatus.fromValue(status!) : null,
        priority: priority != null ? TicketPriority.fromValue(priority!) : null,
        urgency: urgency,
        impact: impact,
        type: type,
        usersIdRecipient: usersIdRecipient,
        date: date != null ? DateTime.tryParse(date!) : null,
        dateMod: dateMod != null ? DateTime.tryParse(dateMod!) : null,
        entitiesId: entitiesId,
        itilcategoriesId: itilcategoriesId,
        locationsId: locationsId,
        latitude: latitude != null ? double.tryParse(latitude!) : null,
        longitude: longitude != null ? double.tryParse(longitude!) : null,
        requesttypesId: requesttypesId,
        ticketsId: ticketsId,
        usersIdLastUpdater: usersIdLastUpdater,
        solvedate: solvedate != null ? DateTime.tryParse(solvedate!) : null,
        closedate: closedate != null ? DateTime.tryParse(closedate!) : null,
        slasId: slasId,
        olasId: olasId,
        internalTimeToResolve: internalTimeToResolve,
        internalTimeToOwn: internalTimeToOwn,
        waitingDuration: waitingDuration,
        closeDelayStat: closeDelayStat,
        solveDelayStat: solveDelayStat,
        takeintoaccountDelayStat: takeintoaccountDelayStat,
        actiontime: actiontime,
        isDeleted: isDeleted == 1,
        locationsIdField: locationsIdField,
        links: links,
        usersIdAssign: _usersIdAssign?.cast<int>(),
        usersIdRequester: _usersIdRequester?.cast<int>(),
        usersIdObserver: _usersIdObserver?.cast<int>(),
        groupsIdAssign: _groupsIdAssign?.cast<int>(),
        groupsIdRequester: _groupsIdRequester?.cast<int>(),
        groupsIdObserver: _groupsIdObserver?.cast<int>(),
      );

  factory TicketModel.fromEntity(Ticket ticket) => TicketModel(
        id: ticket.id,
        name: ticket.name,
        content: ticket.content,
        status: ticket.status?.value,
        priority: ticket.priority?.value,
        urgency: ticket.urgency,
        impact: ticket.impact,
        type: ticket.type,
        usersIdRecipient: ticket.usersIdRecipient,
        date: ticket.date?.toIso8601String(),
        dateMod: ticket.dateMod?.toIso8601String(),
        entitiesId: ticket.entitiesId,
        itilcategoriesId: ticket.itilcategoriesId,
        locationsId: ticket.locationsId,
        latitude: ticket.latitude?.toString(),
        longitude: ticket.longitude?.toString(),
        requesttypesId: ticket.requesttypesId,
        ticketsId: ticket.ticketsId,
        usersIdLastUpdater: ticket.usersIdLastUpdater,
        solvedate: ticket.solvedate?.toIso8601String(),
        closedate: ticket.closedate?.toIso8601String(),
        slasId: ticket.slasId,
        olasId: ticket.olasId,
        internalTimeToResolve: ticket.internalTimeToResolve,
        internalTimeToOwn: ticket.internalTimeToOwn,
        waitingDuration: ticket.waitingDuration,
        closeDelayStat: ticket.closeDelayStat,
        solveDelayStat: ticket.solveDelayStat,
        takeintoaccountDelayStat: ticket.takeintoaccountDelayStat,
        actiontime: ticket.actiontime,
        isDeleted: ticket.isDeleted ? 1 : 0,
        locationsIdField: ticket.locationsIdField,
        links: ticket.links,
        usersIdAssign: ticket.usersIdAssign,
        usersIdRequester: ticket.usersIdRequester,
        usersIdObserver: ticket.usersIdObserver,
        groupsIdAssign: ticket.groupsIdAssign,
        groupsIdRequester: ticket.groupsIdRequester,
        groupsIdObserver: ticket.groupsIdObserver,
      );
}