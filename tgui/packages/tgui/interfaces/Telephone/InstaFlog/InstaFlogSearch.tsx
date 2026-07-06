import { useMemo, useState } from 'react';
import { Box } from 'tgui-core/components';
import type { InstaFlogProfile } from '..';
import {
  instaflogFadeIn,
  instaflogFullWidth,
  instaflogInsetField,
  instaflogPanel,
} from '../instaflogStyles';
import { InstaFlogAvatar } from './InstaFlogComponents';

type SearchProps = {
  profiles: Record<string, InstaFlogProfile>;
  onViewProfile: (username: string) => void;
  onClickSound: () => void;
};

const normalizeHandle = (query: string) =>
  query
    .trim()
    .toLowerCase()
    .replace(/^@+/, '')
    .replace(/\s+/g, '_')
    .replace(/[^a-z0-9_]/g, '')
    .slice(0, 16);

const rankProfileMatch = (profile: InstaFlogProfile, query: string) => {
  const username = profile.username.toLowerCase();
  const displayName = (profile.display_name || '').toLowerCase();
  if (!query) {
    return 0;
  }
  if (username === query) {
    return 100;
  }
  if (username.startsWith(query)) {
    return 80;
  }
  if (displayName === query) {
    return 70;
  }
  if (displayName.startsWith(query)) {
    return 60;
  }
  if (username.includes(query)) {
    return 40;
  }
  if (displayName.includes(query)) {
    return 30;
  }
  return 0;
};

export const InstaFlogSearch = (props: SearchProps) => {
  const { profiles, onViewProfile, onClickSound } = props;
  const [query, setQuery] = useState('');

  const normalizedQuery = normalizeHandle(query);

  const results = useMemo(() => {
    const entries = Object.values(profiles);
    if (!normalizedQuery) {
      return entries
        .sort((a, b) => a.username.localeCompare(b.username))
        .slice(0, 24);
    }
    return entries
      .map((profile) => ({
        profile,
        score: rankProfileMatch(profile, normalizedQuery),
      }))
      .filter((entry) => entry.score > 0)
      .sort((a, b) => {
        const scoreDiff = b.score - a.score;
        if (scoreDiff !== 0) {
          return scoreDiff;
        }
        return a.profile.username.localeCompare(b.profile.username);
      })
      .map((entry) => entry.profile);
  }, [profiles, normalizedQuery]);

  return (
    <div
      className="InstaFlog__Feed"
      style={{ ...instaflogFullWidth, ...instaflogFadeIn }}
    >
      <div
        className="InstaFlog__Panel"
        style={{ ...instaflogPanel, padding: '8px', borderRadius: '10px', marginBottom: '8px' }}
      >
        <Box fontSize="10px" bold color="#4a2f0e" mb={0.5}>
          Buscar perfis
        </Box>
        <input
          className="InstaFlog__FormField"
          style={instaflogInsetField}
          value={query}
          maxLength={16}
          placeholder="@usuario"
          onChange={(event) => setQuery(event.target.value)}
        />
        <Box fontSize="9px" color="#8a6a3c" mt={0.5}>
          {normalizedQuery
            ? `Resultados para @${normalizedQuery}`
            : 'Perfis recentes — digite um @ para buscar'}
        </Box>
      </div>

      {results.length === 0 ? (
        <Box textAlign="center" color="#6d4a1f" fontSize="11px" mt={1}>
          Nenhum perfil encontrado para @{normalizedQuery}.
        </Box>
      ) : (
        results.map((profile) => (
          <div
            key={profile.username}
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
              onViewProfile(profile.username);
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
                {profile.bio ? (
                  <Box fontSize="9px" color="#6d4a1f" mt={0.25} italic>
                    {profile.bio}
                  </Box>
                ) : null}
              </div>
            </div>
          </div>
        ))
      )}
    </div>
  );
};