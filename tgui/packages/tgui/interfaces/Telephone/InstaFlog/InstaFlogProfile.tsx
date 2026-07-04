import { useState } from 'react';
import { Box } from 'tgui-core/components';
import type { InstaFlogAccount, InstaFlogPost, InstaFlogProfile } from '..';
import { instaflogFadeIn, instaflogFullWidth, instaflogPanel } from '../instaflogStyles';
import { InstaFlogAvatar } from './InstaFlogComponents';
import { InstaFlogPostCard } from './InstaFlogPostCard';

type ProfileViewProps = {
  profile: InstaFlogProfile | InstaFlogAccount;
  posts: InstaFlogPost[];
  postCount?: number;
  isOwnProfile?: boolean;
  onEdit?: () => void;
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
    onEdit,
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

  return (
    <div style={{ ...instaflogFullWidth, ...instaflogFadeIn }}>
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
                📍 {profile.city}
              </Box>
            ) : null}
            <Box fontSize="10px" color="#8a6a3c" mt={0.5}>
              {count} flogs
            </Box>
          </div>
        </div>
        {profile.bio ? (
          <Box mt={1} fontSize="11px" color="#3b2b16">
            {profile.bio}
          </Box>
        ) : null}
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
