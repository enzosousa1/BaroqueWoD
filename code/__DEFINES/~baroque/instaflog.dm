#define INSTAFLOG_MAX_USERNAME 16
#define INSTAFLOG_MAX_DISPLAY_NAME 24
#define INSTAFLOG_MAX_BIO 140
#define INSTAFLOG_MAX_CITY 32
#define INSTAFLOG_MAX_POST_BODY 280
#define INSTAFLOG_MAX_PROFILE_URL 512
#define INSTAFLOG_MAX_COMMENT_BODY 200

/// Global feed cap — oldest posts are removed when exceeded.
#define INSTAFLOG_MAX_FEED_POSTS 80
/// Posts serialized to TGUI per refresh (prevents UI/network overload).
#define INSTAFLOG_MAX_UI_POSTS 40
/// Per-phone posting cap each round.
#define INSTAFLOG_MAX_POSTS_PER_ROUND 12
#define INSTAFLOG_MAX_COMMENTS_PER_POST 30
/// Base64 JPEG payload cap (characters) sent to clients.
#define INSTAFLOG_MAX_IMAGE_BASE64 65536

#define INSTAFLOG_POST_COOLDOWN 30 SECONDS
#define INSTAFLOG_COMMENT_COOLDOWN 5 SECONDS
#define INSTAFLOG_LIKE_COOLDOWN 1 SECONDS
#define INSTAFLOG_FOLLOW_COOLDOWN 2 SECONDS