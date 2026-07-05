import { useMemo } from 'react';
import { Box } from 'tgui-core/components';
import type { InstaFlogPost } from '..';
import { instaflogFadeIn, instaflogFullWidth } from '../instaflogStyles';
import type { InstaFlogTab } from './InstaFlogComponents';
import { InstaFlogPostCard } from './InstaFlogPostCard';

type FeedProps = {
  tab: InstaFlogTab;
  posts: InstaFlogPost[];
  following?: string[];
  ownUsername?: string;
  onLike: (postId: number) => void;
  onComment: (postId: number, body: string) => void;
  onDelete: (postId: number) => void;
  onViewProfile: (username: string) => void;
  onClickSound: () => void;
};

const filterPosts = (
  posts: InstaFlogPost[],
  tab: InstaFlogTab,
  following: string[],
  ownUsername?: string,
) => {
  if (tab !== 'home') {
    return posts;
  }
  const followed = new Set(following);
  if (ownUsername) {
    followed.add(ownUsername);
  }
  if (followed.size === 0) {
    return posts;
  }
  return posts.filter((post) => followed.has(post.username));
};

const sortPosts = (posts: InstaFlogPost[], tab: InstaFlogTab) => {
  const sorted = [...posts];
  if (tab === 'trending') {
    sorted.sort((a, b) => {
      const likeDiff = (b.like_count ?? 0) - (a.like_count ?? 0);
      if (likeDiff !== 0) {
        return likeDiff;
      }
      return (b.timestamp ?? 0) - (a.timestamp ?? 0);
    });
    return sorted;
  }
  sorted.sort((a, b) => (b.timestamp ?? 0) - (a.timestamp ?? 0));
  return sorted;
};

export const InstaFlogFeed = (props: FeedProps) => {
  const {
    tab,
    posts,
    following = [],
    ownUsername,
    onLike,
    onComment,
    onDelete,
    onViewProfile,
    onClickSound,
  } = props;

  const sortedPosts = useMemo(
    () => sortPosts(filterPosts(posts, tab, following, ownUsername), tab),
    [posts, tab, following, ownUsername],
  );

  if (sortedPosts.length === 0) {
    return (
      <Box
        className="InstaFlog__Feed"
        textAlign="center"
        color="#6d4a1f"
        fontSize="11px"
        pt={0.5}
      >
        {tab === 'home' && following.length > 0
          ? 'Nenhuma postagem de quem você segue. Siga mais perfis!'
          : 'Nenhum flog ainda. Seja o primeiro!'}
      </Box>
    );
  }

  return (
    <div
      className="InstaFlog__Feed"
      style={{ ...instaflogFullWidth, ...instaflogFadeIn }}
    >
      {sortedPosts.map((post) => (
        <InstaFlogPostCard
          key={post.post_id}
          post={post}
          onLike={() => onLike(post.post_id)}
          onComment={(body) => onComment(post.post_id, body)}
          onDelete={() => onDelete(post.post_id)}
          onViewProfile={onViewProfile}
          onClickSound={onClickSound}
        />
      ))}
    </div>
  );
};