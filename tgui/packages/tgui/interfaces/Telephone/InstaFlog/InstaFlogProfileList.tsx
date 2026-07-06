import { Box } from 'tgui-core/components';
import type { InstaFlogProfile } from '..';
import { instaflogFadeIn, instaflogFullWidth, instaflogPanel } from '../instaflogStyles';
import { InstaFlogAvatar } from './InstaFlogComponents';

type ProfileListProps = {
  title: string;
  usernames: string[];
  profiles: Record<string, InstaFlogProfile>;
  emptyMessage: string;
  onBack: () => void;
  onViewProfile: (username: string) => void;
  onClickSound: () => void;
};

const resolveListProfile = (
  username: string,
  profiles: Record<string, InstaFlogProfile>,
): InstaFlogProfile => {
  const profile = profiles[username];
  if (profile) {
    return profile;
  }
  return {
    username,
    display_name: username,
    bio: '',
    city: '',
    profile_photo_url: '',
  };
};

export const InstaFlogProfileList = (props: ProfileListProps) => {
  const {
    title,
    usernames,
    profiles,
    emptyMessage,
    onBack,
    onViewProfile,
    onClickSound,
  } = props;

  return (
    <div
      className="InstaFlog__Feed"
      style={{ ...instaflogFullWidth, ...instaflogFadeIn }}
    >
      <div
        className="InstaFlog__Panel"
        style={{ ...instaflogPanel, padding: '8px', borderRadius: '10px', marginBottom: '8px' }}
      >
        <Box
          fontSize="10px"
          bold
          color="#6d3f10"
          mb={0.5}
          style={{ cursor: 'pointer', textDecoration: 'underline' }}
          onClick={() => {
            onClickSound();
            onBack();
          }}
        >
          ← Voltar ao perfil
        </Box>
        <Box bold color="#4a2f0e" fontSize="12px">
          {title}
        </Box>
      </div>

      {usernames.length === 0 ? (
        <Box textAlign="center" color="#6d4a1f" fontSize="11px" mt={1}>
          {emptyMessage}
        </Box>
      ) : (
        usernames.map((username) => {
          const profile = resolveListProfile(username, profiles);
          return (
            <div
              key={username}
              className="InstaFlog__Panel"
              style={{
                ...instaflogPanel,
                padding: '8px',
                borderRadius: '8px',
                marginBottom: '6px',
                cursor: 'pointer',
              }}
              onClick={() => {
                onClickSound();
                onViewProfile(username);
              }}
            >
              <div className="InstaFlog__PostHeader">
                <InstaFlogAvatar
                  url={profile.profile_photo_url}
                  usable={profile.profile_photo_usable}
                  label={profile.display_name || profile.username}
                  size={40}
                />
                <div className="InstaFlog__PostMeta">
                  <Box bold color="#4a2f0e" fontSize="11px">
                    {profile.display_name}
                  </Box>
                  <Box fontSize="10px" color="#7a5528">
                    @{profile.username}
                  </Box>
                  {profile.city ? (
                    <Box fontSize="9px" color="#8a6a3c" mt={0.25}>
                      {profile.city}
                    </Box>
                  ) : null}
                </div>
              </div>
            </div>
          );
        })
      )}
    </div>
  );
};