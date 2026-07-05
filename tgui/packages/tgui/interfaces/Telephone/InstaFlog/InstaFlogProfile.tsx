import { useState } from 'react';
import { Box, Icon } from 'tgui-core/components';
import type { InstaFlogPost, InstaFlogProfile } from '..';
import { instaflogFadeIn, instaflogFullWidth, instaflogPanel } from '../instaflogStyles';
import { GlossButton, InstaFlogAvatar } from './InstaFlogComponents';
import { InstaFlogPostCard } from './InstaFlogPostCard';

type ProfileViewProps = {
  profile: InstaFlogProfile;
  posts: InstaFlogPost[];
  postCount?: number;
  isOwnProfile?: boolean;
  isFollowedByViewer?: boolean;
  onEdit?: () => void;
  onLogout?: () => void;
  onFollow?: () => void;
  onLike: (postId: number) => void;
  onComment: (postId: number, body: string) => void;
  onDelete: (postId: number) => void;
  onViewProfile: (username: string) => void;
  onClickSound: () => void;
};

export const InstaFlogProfileView = (props: ProfileViewProps) => {
  const {
    profile,
    posts,
    postCount,
    isOwnProfile,
    isFollowedByViewer,
    onEdit,
    onLogout,
    onFollow,
    onLike,
    onComment,
    onDelete,
    onViewProfile,
    onClickSound,
  } = props;

  const [photoLoadFailed, setPhotoLoadFailed] = useState(false);

  const userPosts = posts
    .filter((post) => post.username === profile.username)
    .sort((a, b) => (b.timestamp ?? 0) - (a.timestamp ?? 0));

  const count = postCount ?? userPosts.length;
  const followerCount = profile.follower_count ?? 0;
  const followingCount = profile.following_count ?? 0;

  return (
    <div
      className="InstaFlog__Feed"
      style={{ ...instaflogFullWidth, ...instaflogFadeIn }}
    >
      <div
        className="InstaFlog__Panel"
        style={{ ...instaflogPanel, padding: '10px', borderRadius: '10px', marginBottom: '8px' }}
      >
        <div className="InstaFlog__PostHeader">
          <InstaFlogAvatar
            url={profile.profile_photo_url}
            usable={profile.profile_photo_usable}
            label={profile.display_name || profile.username}
            size={52}
            onImageError={() => setPhotoLoadFailed(true)}
          />
          <div className="InstaFlog__PostMeta">
            <div className="InstaFlog__PostTitleRow">
              <Box bold color="#4a2f0e" fontSize="12px">
                {profile.display_name}
              </Box>
              {isOwnProfile && onEdit && (
                <Box
                  fontSize="9px"
                  bold
                  color="#6d3f10"
                  style={{ cursor: 'pointer', textDecoration: 'underline', flexShrink: 0 }}
                  onClick={() => {
                    onClickSound();
                    onEdit();
                  }}
                >
                  Editar
                </Box>
              )}
            </div>
            <Box color="#7a5528" fontSize="10px">
              @{profile.username}
            </Box>
            {profile.city ? (
              <Box fontSize="10px" color="#6d4a1f" mt={0.25}>
                <Icon name="map-marker" mr={0.25} />
                {profile.city}
              </Box>
            ) : null}
            <Box fontSize="10px" color="#8a6a3c" mt={0.5}>
              <Icon name="image" mr={0.25} />
              {count} flogs
              <span style={{ margin: '0 6px' }}>•</span>
              <Icon name="users" mr={0.25} />
              {followerCount} seguidores
              <span style={{ margin: '0 6px' }}>•</span>
              {followingCount} seguindo
            </Box>
          </div>
        </div>
        {profile.bio ? (
          <Box mt={1} fontSize="11px" color="#3b2b16">
            {profile.bio}
          </Box>
        ) : null}
        <Box mt={1} className="InstaFlog__ActionRow">
          {!isOwnProfile && onFollow && (
            <GlossButton
              tone={isFollowedByViewer ? 'gray' : 'green'}
              onClick={() => {
                onClickSound();
                onFollow();
              }}
            >
              <Icon
                name={isFollowedByViewer ? 'user-times' : 'user-plus'}
                mr={0.25}
              />
              {isFollowedByViewer ? 'Deixar de seguir' : 'Seguir'}
            </GlossButton>
          )}
          {isOwnProfile && onLogout && (
            <GlossButton
              tone="gray"
              onClick={() => {
                onClickSound();
                onLogout();
              }}
            >
              <Icon name="sign-out" mr={0.25} />
              Sair
            </GlossButton>
          )}
        </Box>
        {profile.profile_photo_url &&
        (!profile.profile_photo_usable || photoLoadFailed) ? (
          <Box mt={0.5} fontSize="9px" color="#a83232">
            Foto de perfil indisponível — usando avatar padrão.
          </Box>
        ) : null}
      </div>

      {userPosts.length === 0 ? (
        <Box textAlign="center" color="#6d4a1f" fontSize="11px" mt={1}>
          Nenhuma postagem ainda.
        </Box>
      ) : (
        userPosts.map((post) => (
          <InstaFlogPostCard
            key={post.post_id}
            post={post}
            onLike={() => onLike(post.post_id)}
            onComment={(body) => onComment(post.post_id, body)}
            onDelete={() => onDelete(post.post_id)}
            onViewProfile={onViewProfile}
            onClickSound={onClickSound}
          />
        ))
      )}
    </div>
  );
};
