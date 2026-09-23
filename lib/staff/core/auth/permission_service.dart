import 'package:flutter/foundation.dart';

/// NOTE: This is a FRONTEND-ONLY mock permission system for UI behavior.
/// This does not provide actual security. Real authorization will be enforced 
/// by the backend in a production environment.

class AppPermissions {
  // Articles
  static const String articlesView = 'articles.view';
  static const String articlesCreate = 'articles.create';
  static const String articlesEdit = 'articles.edit';
  static const String articlesDelete = 'articles.delete';
  static const String articlesPublish = 'articles.publish';

  // Pages
  static const String pagesView = 'pages.view';
  static const String pagesCreate = 'pages.create';
  static const String pagesEdit = 'pages.edit';
  static const String pagesDelete = 'pages.delete';

  // Programs
  static const String programsView = 'programs.view';
  static const String programsCreate = 'programs.create';
  static const String programsEdit = 'programs.edit';
  static const String programsDelete = 'programs.delete';

  // Events
  static const String eventsView = 'events.view';
  static const String eventsCreate = 'events.create';
  static const String eventsEdit = 'events.edit';
  static const String eventsDelete = 'events.delete';

  // Media
  static const String mediaView = 'media.view';
  static const String mediaUpload = 'media.upload';
  static const String mediaDelete = 'media.delete';
  static const String mediaGalleryCreate = 'media.gallery.create';

  // Announcements
  static const String announcementsView = 'announcements.view';
  static const String announcementsCreate = 'announcements.create';
  static const String announcementsEdit = 'announcements.edit';
  static const String announcementsDelete = 'announcements.delete';

  // Messages
  static const String messagesView = 'messages.view';
  static const String messagesReply = 'messages.reply';
  static const String messagesResolve = 'messages.resolve';

  // Members
  static const String membersView = 'members.view';
  static const String membersManage = 'members.manage';

  // Reports
  static const String reportsView = 'reports.view';
  static const String reportsExport = 'reports.export';

  // SEO
  static const String seoManage = 'seo.manage';
}

enum MockRole { admin, editor, moderator, viewer }

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  static ValueNotifier<MockRole> currentRole = ValueNotifier<MockRole>(MockRole.admin);

  static final Map<MockRole, Set<String>> _rolePermissions = {
    MockRole.admin: {
      ..._allPermissions,
    },
    MockRole.editor: {
      AppPermissions.articlesView, AppPermissions.articlesCreate, AppPermissions.articlesEdit, AppPermissions.articlesPublish,
      AppPermissions.pagesView, AppPermissions.pagesEdit,
      AppPermissions.programsView, AppPermissions.programsEdit,
      AppPermissions.eventsView, AppPermissions.eventsEdit,
      AppPermissions.mediaView, AppPermissions.mediaUpload,
      AppPermissions.announcementsView, AppPermissions.announcementsCreate, AppPermissions.announcementsEdit,
      AppPermissions.messagesView, AppPermissions.messagesReply,
    },
    MockRole.moderator: {
      AppPermissions.articlesView,
      AppPermissions.eventsView,
      AppPermissions.mediaView,
      AppPermissions.announcementsView,
      AppPermissions.messagesView, AppPermissions.messagesReply, AppPermissions.messagesResolve,
    },
    MockRole.viewer: {
      AppPermissions.articlesView,
      AppPermissions.pagesView,
      AppPermissions.programsView,
      AppPermissions.eventsView,
      AppPermissions.mediaView,
      AppPermissions.announcementsView,
      AppPermissions.messagesView,
    },
  };

  static Set<String> get _allPermissions => {
    AppPermissions.articlesView, AppPermissions.articlesCreate, AppPermissions.articlesEdit, AppPermissions.articlesDelete, AppPermissions.articlesPublish,
    AppPermissions.pagesView, AppPermissions.pagesCreate, AppPermissions.pagesEdit, AppPermissions.pagesDelete,
    AppPermissions.programsView, AppPermissions.programsCreate, AppPermissions.programsEdit, AppPermissions.programsDelete,
    AppPermissions.eventsView, AppPermissions.eventsCreate, AppPermissions.eventsEdit, AppPermissions.eventsDelete,
    AppPermissions.mediaView, AppPermissions.mediaUpload, AppPermissions.mediaDelete, AppPermissions.mediaGalleryCreate,
    AppPermissions.announcementsView, AppPermissions.announcementsCreate, AppPermissions.announcementsEdit, AppPermissions.announcementsDelete,
    AppPermissions.messagesView, AppPermissions.messagesReply, AppPermissions.messagesResolve,
    AppPermissions.membersView, AppPermissions.membersManage,
    AppPermissions.reportsView, AppPermissions.reportsExport,
    AppPermissions.seoManage,
  };

  static bool hasPermission(String permission) {
    return _rolePermissions[currentRole.value]?.contains(permission) ?? false;
  }

  static void setRole(MockRole role) {
    currentRole.value = role;
  }
}
