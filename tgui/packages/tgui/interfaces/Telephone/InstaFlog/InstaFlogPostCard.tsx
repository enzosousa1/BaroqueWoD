import { useState } from 'react';
import { Box } from 'tgui-core/components';
import type { InstaFlogPost } from '..';
import { instaflogCard, instaflogInsetField } from '../instaflogStyles';
import {
  convertTo12Hour,
  GlossButton,
  InstaFlogAvatar,
} from './InstaFlogComponents';

type PostCardProps = {
  post: InstaFlogPost;
  onLike: () => void;
  onComment: (body: string) => void;
  onDelete?: () => void;
  onViewProfile: (username: string) => void;
  onClickSound: () => void;
};

export const InstaFlogPostCard = (props: PostCardProps) => {
  const {
    post,
    onLike,
    onComment,
    onDelete,
    onViewProfile,
    onClickSound,
  } = props;
  const [commentOpen, setCommentOpen] = useState(false);
  const [commentBody, setCommentBody] = useState('');
  const canDelete = !!post.can_delete;

  const handleComment = () => {
    if (!commentBody.trim()) {
      return;
    }
    onClickSound();
    onComment(commentBody.trim());
    setCommentBody('');
    setCommentOpen(false);
  };

  return (
    <div
      className="InstaFlog__Card"
      style={{ ...instaflogCard, padding: '8px', marginBottom: '8px' }}
    >
      <div className="InstaFlog__PostHeader">
        <InstaFlogAvatar
          url={post.profile_photo_url}
          usable={post.profile_photo_usable}
          label={post.display_name || post.username}
          size={38}
          onClick={() => onViewProfile(post.username)}
        />
        <div className="InstaFlog__PostMeta">
          <div className="InstaFlog__PostTitleRow">
            <Box
              bold
              color="#4a2f0e"
              fontSize="11px"
              style={{
                cursor: 'pointer',
                minWidth: 0,
                overflow: 'hidden',
                textOverflow: 'ellipsis',
              }}
              onClick={() => onViewProfile(post.username)}
            >
              {post.display_name}
            </Box>
            <Box
              fontSize="8px"
              color="#8a6a3c"
              textAlign="right"
              style={{ flexShrink: 0, lineHeight: 1.2 }}
            >
              {post.date}
              <br />
              {convertTo12Hour(post.time)}
            </Box>
          </div>
          <Box
            fontSize="9px"
            color="#7a5528"
            style={{ cursor: 'pointer' }}
            onClick={() => onViewProfile(post.username)}
          >
            @{post.username}
            {post.city ? ` • ${post.city}` : ''}
          </Box>
        </div>
      </div>

      <Box
        mt={1}
        fontSize="11px"
        color="#3b2b16"
        style={{ whiteSpace: 'pre-wrap', wordBreak: 'break-word' }}
      >
        {post.body}
      </Box>

      {post.image ? (
        <Box mt={1} width="100%">
          <img
            src={`data:image/jpeg;base64,${post.image}`}
            alt="Anexo"
            style={{
              width: '100%',
              maxWidth: '100%',
              borderRadius: '6px',
              border: '2px solid #c9a56d',
              boxShadow: '0 2px 4px rgba(0,0,0,0.2)',
              imageRendering: 'pixelated',
              display: 'block',
            }}
          />
        </Box>
      ) : null}

      <div className="InstaFlog__ActionRow" style={{ marginTop: '8px' }}>
        <GlossButton
          tone={post.liked_by_me ? 'pink' : 'gray'}
          onClick={() => {
            onClickSound();
            onLike();
          }}
        >
          {post.liked_by_me ? '♥' : '♡'} {post.like_count}
        </GlossButton>
        <GlossButton tone="gray" onClick={() => setCommentOpen(!commentOpen)}>
          💬 {post.comments?.length ?? 0}
        </GlossButton>
        {canDelete && onDelete && (
          <GlossButton tone="gray" onClick={onDelete}>
            Apagar
          </GlossButton>
        )}
      </div>

      {commentOpen && (
        <div className="InstaFlog__CommentRow" style={{ marginTop: '8px' }}>
          <input
            className="InstaFlog__FormField"
            style={instaflogInsetField}
            value={commentBody}
            maxLength={200}
            placeholder="Comentário..."
            onChange={(event) => setCommentBody(event.target.value)}
          />
          <GlossButton tone="green" onClick={handleComment}>
            OK
          </GlossButton>
        </div>
      )}

      {(post.comments?.length ?? 0) > 0 && (
        <Box mt={1} pl={1} style={{ borderLeft: '2px solid #d2b98d' }}>
          {post.comments!.map((comment, index) => (
            <Box key={`${comment.username}-${index}`} mb={0.5} fontSize="10px">
              <Box bold color="#4a2f0e" inline>
                {comment.display_name}
              </Box>
              <Box color="#3b2b16" ml={0.5} inline>
                {comment.body}
              </Box>
            </Box>
          ))}
        </Box>
      )}
    </div>
  );
};