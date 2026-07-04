// THIS IS A BAROQUE UI FILE
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box } from 'tgui-core/components';
import type { Data, InstaFlogProfile, NavigableApps } from '.';
import { InstaFlogCompose } from './InstaFlog/InstaFlogCompose';
import {
  InstaFlogAppHeader,
  InstaFlogBottomNav,
  type InstaFlogTab,
} from './InstaFlog/InstaFlogComponents';
import { InstaFlogFeed } from './InstaFlog/InstaFlogFeed';
import { InstaFlogProfileView } from './InstaFlog/InstaFlogProfile';
import { InstaFlogRegistration } from './InstaFlog/InstaFlogRegistration';
import { InstaFlogScreen } from './InstaFlog/InstaFlogScreen';
import { instaflogBottomNav } from './instaflogStyles';

export const ScreenInstaFlog = (props: {
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { setApp } = props;
  const { act, data } = useBackend<Data>();
  const account = data.instaflog_account;
  const registered = !!data.instaflog_registered;
  const posts = data.instaflog_posts ?? [];
  const profiles = data.instaflog_profiles ?? {};
  const photos = data.photos ?? [];

  const [activeTab, setActiveTab] = useState<InstaFlogTab>('home');
  const [editingProfile, setEditingProfile] = useState(false);
  const [viewingUsername, setViewingUsername] = useState<string | null>(null);

  const clickSound = () => act('keyboard_click');

  if (!registered || editingProfile) {
    return (
      <InstaFlogRegistration
        initial={account}
        isUpdate={registered}
        onBack={() => {
          if (registered) {
            setEditingProfile(false);
          } else {
            clickSound();
            setApp(null);
          }
        }}
        onSubmit={(fields) => {
          act('instaflog_register', fields);
          setEditingProfile(false);
          setActiveTab('profile');
        }}
        onClickSound={clickSound}
      />
    );
  }

  const resolveProfile = (username: string): InstaFlogProfile | null => {
    const fromRegistry = profiles[username];
    if (fromRegistry) {
      return fromRegistry;
    }
    const latestPost = posts.find((post) => post.username === username);
    if (!latestPost) {
      return null;
    }
    return {
      username: latestPost.username,
      display_name: latestPost.display_name,
      bio: '',
      city: latestPost.city,
      profile_photo_url: latestPost.profile_photo_url,
      profile_photo_usable: latestPost.profile_photo_usable,
      post_count: posts.filter((post) => post.username === username).length,
    };
  };

  const handleViewProfile = (username: string) => {
    clickSound();
    setViewingUsername(username);
    setActiveTab('profile');
  };

  const profileUsername = viewingUsername ?? account?.username ?? '';
  const viewedProfile = resolveProfile(profileUsername);

  const renderContent = () => {
    if (activeTab === 'compose') {
      return (
        <InstaFlogCompose
          photos={photos}
          onSubmit={(body, galleryPhotoId) => {
            act('submit_post', {
              body,
              gallery_photo_id: galleryPhotoId,
            });
            setActiveTab('home');
          }}
          onCancel={() => setActiveTab('home')}
          onClickSound={clickSound}
        />
      );
    }

    if (activeTab === 'profile' && viewedProfile) {
      return (
        <InstaFlogProfileView
          profile={viewedProfile}
          posts={posts}
          postCount={viewedProfile.post_count}
          isOwnProfile={profileUsername === account?.username}
          onEdit={() => setEditingProfile(true)}
          onLike={(postId) => act('instaflog_like', { post_id: postId })}
          onComment={(postId, body) =>
            act('instaflog_comment', { post_id: postId, body })
          }
          onDelete={(postId) => act('instaflog_delete_post', { post_id: postId })}
          onViewProfile={handleViewProfile}
          onClickSound={clickSound}
        />
      );
    }

    if (activeTab === 'profile') {
      return (
        <Box textAlign="center" color="#6d4a1f" fontSize="11px" mt={2}>
          Perfil não encontrado.
        </Box>
      );
    }

    return (
      <InstaFlogFeed
        tab={activeTab}
        posts={posts}
        onLike={(postId) => act('instaflog_like', { post_id: postId })}
        onComment={(postId, body) =>
          act('instaflog_comment', { post_id: postId, body })
        }
        onDelete={(postId) => act('instaflog_delete_post', { post_id: postId })}
        onViewProfile={handleViewProfile}
        onClickSound={clickSound}
      />
    );
  };

  const tabTitle =
    activeTab === 'home'
      ? 'Início'
      : activeTab === 'trending'
        ? 'Em Alta'
        : activeTab === 'compose'
          ? 'Nova postagem'
          : viewingUsername && viewingUsername !== account?.username
            ? `@${viewingUsername}`
            : 'Meu perfil';

  return (
    <InstaFlogScreen
      centered={activeTab === 'compose'}
      header={
        <InstaFlogAppHeader
          title={tabTitle}
          onBack={() => {
            clickSound();
            setApp(null);
          }}
        />
      }
      footer={
        <Box style={instaflogBottomNav}>
          <InstaFlogBottomNav
            activeTab={activeTab}
            onTabChange={(tab) => {
              if (tab === 'profile') {
                setViewingUsername(null);
              }
              setActiveTab(tab);
            }}
            onClickSound={clickSound}
          />
        </Box>
      }
    >
      {renderContent()}
    </InstaFlogScreen>
  );
};