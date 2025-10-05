import 'package:equatable/equatable.dart';

enum TicketStatus {
  newTicket(1),
  assigned(2),
  planned(3),
  pending(4),
  solved(5),
  closed(6);

  const TicketStatus(this.value);
  final int value;

  factory TicketStatus.fromValue(int value) {
    return TicketStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TicketStatus.newTicket,
    );
  }
}

enum TicketPriority {
  veryLow(1),
  low(2),
  medium(3),
  high(4),
  veryHigh(5),
  major(6);

  const TicketPriority(this.value);
  final int value;

  factory TicketPriority.fromValue(int value) {
    return TicketPriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => TicketPriority.medium,
    );
  }
}

class Ticket extends Equatable {
  final int id;
  final String name;
  final String? content;
  final TicketStatus? status;
  final TicketPriority? priority;
  final int? urgency;
  final int? impact;
  final int? type;
  final int? usersIdRecipient;
  final DateTime? date;
  final DateTime? dateMod;
  final int? entitiesId;
  final int? itilcategoriesId;
  final int? locationsId;
  final double? latitude;
  final double? longitude;
  final int? requesttypesId;
  final int? ticketsId;
  final int? usersIdLastUpdater;
  final DateTime? solvedate;
  final DateTime? closedate;
  final int? slasId;
  final int? olasId;
  final String? internalTimeToResolve;
  final String? internalTimeToOwn;
  final String? waitingDuration;
  final String? closeDelayStat;
  final String? solveDelayStat;
  final String? takeintoaccountDelayStat;
  final String? actiontime;
  final bool isDeleted;
  final String? locationsIdField;
  final String? links;
  final List<int>? usersIdAssign;
  final List<int>? usersIdRequester;
  final List<int>? usersIdObserver;
  final List<int>? groupsIdAssign;
  final List<int>? groupsIdRequester;
  final List<int>? groupsIdObserver;

  const Ticket({
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
    this.isDeleted = false,
    this.locationsIdField,
    this.links,
    this.usersIdAssign,
    this.usersIdRequester,
    this.usersIdObserver,
    this.groupsIdAssign,
    this.groupsIdRequester,
    this.groupsIdObserver,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        content,
        status,
        priority,
        urgency,
        impact,
        type,
        usersIdRecipient,
        date,
        dateMod,
        entitiesId,
        itilcategoriesId,
        locationsId,
        latitude,
        longitude,
        requesttypesId,
        ticketsId,
        usersIdLastUpdater,
        solvedate,
        closedate,
        slasId,
        olasId,
        internalTimeToResolve,
        internalTimeToOwn,
        waitingDuration,
        closeDelayStat,
        solveDelayStat,
        takeintoaccountDelayStat,
        actiontime,
        isDeleted,
        locationsIdField,
        links,
        usersIdAssign,
        usersIdRequester,
        usersIdObserver,
        groupsIdAssign,
        groupsIdRequester,
        groupsIdObserver,
      ];

  Ticket copyWith({
    int? id,
    String? name,
    String? content,
    TicketStatus? status,
    TicketPriority? priority,
    int? urgency,
    int? impact,
    int? type,
    int? usersIdRecipient,
    DateTime? date,
    DateTime? dateMod,
    int? entitiesId,
    int? itilcategoriesId,
    int? locationsId,
    double? latitude,
    double? longitude,
    int? requesttypesId,
    int? ticketsId,
    int? usersIdLastUpdater,
    DateTime? solvedate,
    DateTime? closedate,
    int? slasId,
    int? olasId,
    String? internalTimeToResolve,
    String? internalTimeToOwn,
    String? waitingDuration,
    String? closeDelayStat,
    String? solveDelayStat,
    String? takeintoaccountDelayStat,
    String? actiontime,
    bool? isDeleted,
    String? locationsIdField,
    String? links,
    List<int>? usersIdAssign,
    List<int>? usersIdRequester,
    List<int>? usersIdObserver,
    List<int>? groupsIdAssign,
    List<int>? groupsIdRequester,
    List<int>? groupsIdObserver,
  }) {
    return Ticket(
      id: id ?? this.id,
      name: name ?? this.name,
      content: content ?? this.content,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      urgency: urgency ?? this.urgency,
      impact: impact ?? this.impact,
      type: type ?? this.type,
      usersIdRecipient: usersIdRecipient ?? this.usersIdRecipient,
      date: date ?? this.date,
      dateMod: dateMod ?? this.dateMod,
      entitiesId: entitiesId ?? this.entitiesId,
      itilcategoriesId: itilcategoriesId ?? this.itilcategoriesId,
      locationsId: locationsId ?? this.locationsId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      requesttypesId: requesttypesId ?? this.requesttypesId,
      ticketsId: ticketsId ?? this.ticketsId,
      usersIdLastUpdater: usersIdLastUpdater ?? this.usersIdLastUpdater,
      solvedate: solvedate ?? this.solvedate,
      closedate: closedate ?? this.closedate,
      slasId: slasId ?? this.slasId,
      olasId: olasId ?? this.olasId,
      internalTimeToResolve: internalTimeToResolve ?? this.internalTimeToResolve,
      internalTimeToOwn: internalTimeToOwn ?? this.internalTimeToOwn,
      waitingDuration: waitingDuration ?? this.waitingDuration,
      closeDelayStat: closeDelayStat ?? this.closeDelayStat,
      solveDelayStat: solveDelayStat ?? this.solveDelayStat,
      takeintoaccountDelayStat: takeintoaccountDelayStat ?? this.takeintoaccountDelayStat,
      actiontime: actiontime ?? this.actiontime,
      isDeleted: isDeleted ?? this.isDeleted,
      locationsIdField: locationsIdField ?? this.locationsIdField,
      links: links ?? this.links,
      usersIdAssign: usersIdAssign ?? this.usersIdAssign,
      usersIdRequester: usersIdRequester ?? this.usersIdRequester,
      usersIdObserver: usersIdObserver ?? this.usersIdObserver,
      groupsIdAssign: groupsIdAssign ?? this.groupsIdAssign,
      groupsIdRequester: groupsIdRequester ?? this.groupsIdRequester,
      groupsIdObserver: groupsIdObserver ?? this.groupsIdObserver,
    );
  }

  bool get isOpen => status != TicketStatus.solved && status != TicketStatus.closed;
  bool get isClosed => status == TicketStatus.closed;
  bool get isSolved => status == TicketStatus.solved;
  bool get hasLocation => latitude != null && longitude != null;
}