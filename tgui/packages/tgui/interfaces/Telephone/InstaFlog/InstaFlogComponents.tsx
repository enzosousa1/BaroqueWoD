import { useState } from 'react';
import { Box, Icon, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import {
  instaflogBottomNav,
  instaflogChrome,
  instaflogGlossButton,
  instaflogLogo,
  instaflogNavButton,
} from '../instaflogStyles';

export type InstaFlogTab = 'home' | 'trending' | 'search' | 'compose' | 'profile';

export const convertTo12Hour = (timeStr: string) => {
  if (!timeStr || !timeStr.includes(':')) {
    return timeStr || '';
  }
  const [hourStr, minute] = timeStr.split(':');
  const hour = parseInt(hourStr, 10);
  const period = hour >= 12 ? 'PM' : 'AM';
  const displayHour = hour % 12 || 12;
  return `${displayHour}:${minute} ${period}`;
};

type GlossButtonProps = {
  tone?: 'gold' | 'green' | 'gray' | 'pink';
  onClick?: () => void;
  children: React.ReactNode;
  style?: React.CSSProperties;
};

export const GlossButton = (props: GlossButtonProps) => {
  const { tone = 'gold', onClick, children, style } = props;
  const [pressed, setPressed] = useState(false);

  return (
    <div
      style={{ ...instaflogGlossButton(tone, pressed), ...style }}
      onMouseDown={() => setPressed(true)}
      onMouseUp={() => setPressed(false)}
      onMouseLeave={() => setPressed(false)}
      onClick={onClick}
    >
      {children}
    </div>
  );
};

type AvatarProps = {
  url?: string;
  usable?: BooleanLike;
  label: string;
  size?: number;
  onClick?: () => void;
  onImageError?: () => void;
};

export const InstaFlogAvatar = (props: AvatarProps) => {
  const { url, usable, label, size = 40, onClick, onImageError } = props;
  const [imageFailed, setImageFailed] = useState(false);
  const isUsable = usable === undefined ? true : !!usable;
  const showImage = url && isUsable && !imageFailed;

  return (
    <div
      onClick={onClick}
      style={{
        width: `${size}px`,
        height: `${size}px`,
        borderRadius: '6px',
        border: '2px solid #b8894f',
        boxShadow: 'inset 0 0 6px rgba(0,0,0,0.2), 0 1px 2px rgba(0,0,0,0.25)',
        overflow: 'hidden',
        background: 'linear-gradient(135deg, #f7e3b2, #c58f45)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        flexShrink: 0,
        cursor: onClick ? 'pointer' : 'default',
      }}
    >
      {showImage ? (
        <img
          src={url}
          alt={label}
          style={{ width: '100%', height: '100%', objectFit: 'cover' }}
          onError={() => {
            setImageFailed(true);
            onImageError?.();
          }}
        />
      ) : (
        <span
          style={{
            fontSize: `${Math.round(size * 0.38)}px`,
            fontWeight: 'bold',
            color: '#5c3b14',
          }}
        >
          {label.charAt(0).toUpperCase()}
        </span>
      )}
    </div>
  );
};

export const InstaFlogLogo = () => (
  <Box textAlign="center">
    <Box style={instaflogLogo}>InstaFlog</Box>
    <Box
      fontSize="8px"
      color="#6d4a1f"
      mt={-0.25}
      style={{ textShadow: '0 1px 0 #fff4d8' }}
    >
      seu fotolog • 2010
    </Box>
  </Box>
);

type AppHeaderProps = {
  title: string;
  onBack: () => void;
  /** Single-row header to save vertical space (registration). */
  minimal?: boolean;
};

export const InstaFlogAppHeader = (props: AppHeaderProps) => {
  const { title, onBack, minimal = false } = props;

  if (minimal) {
    return (
      <Box className="InstaFlog__Header InstaFlog__Header--minimal" style={instaflogChrome} px={1} py={0.5} width="100%">
        <Stack fill align="center">
          <Stack.Item>
            <Icon
              name="arrow-left"
              onClick={onBack}
              style={{ cursor: 'pointer' }}
            />
          </Stack.Item>
          <Stack.Item grow textAlign="center">
            <Box bold fontSize="11px" color="#4a2f0e">
              InstaFlog
            </Box>
            <Box fontSize="8px" color="#6d4a1f">
              {title}
            </Box>
          </Stack.Item>
          <Stack.Item width={1.2} />
        </Stack>
      </Box>
    );
  }

  return (
    <Box
      className="InstaFlog__Header"
      style={instaflogChrome}
      px={1}
      py={0.5}
      width="100%"
    >
      <Stack fill align="center" width="100%">
        <Stack.Item>
          <Icon
            name="arrow-left"
            onClick={onBack}
            style={{ cursor: 'pointer' }}
          />
        </Stack.Item>
        <Stack.Item grow textAlign="center">
          <Box style={instaflogLogo} fontSize="13px">
            InstaFlog
          </Box>
          <Box fontSize="8px" color="#6d4a1f" mt={-0.25}>
            {title}
          </Box>
        </Stack.Item>
        <Stack.Item width={1.2} />
      </Stack>
    </Box>
  );
};

type BottomNavProps = {
  activeTab: InstaFlogTab;
  onTabChange: (tab: InstaFlogTab) => void;
  onClickSound: () => void;
};

export const InstaFlogBottomNav = (props: BottomNavProps) => {
  const { activeTab, onTabChange, onClickSound } = props;

  const tabs: { id: InstaFlogTab; label: string; icon: string }[] = [
    { id: 'home', label: 'Início', icon: 'home' },
    { id: 'trending', label: 'Em Alta', icon: 'fire' },
    { id: 'search', label: 'Buscar', icon: 'search' },
    { id: 'compose', label: 'Flog', icon: 'plus' },
    { id: 'profile', label: 'Perfil', icon: 'user' },
  ];

  return (
    <nav className="InstaFlog__BottomNav" style={instaflogBottomNav}>
      {tabs.map((tab) => (
        <div
          key={tab.id}
          className="InstaFlog__NavButton"
          style={instaflogNavButton(activeTab === tab.id)}
          onClick={() => {
            onClickSound();
            onTabChange(tab.id);
          }}
        >
          <Icon name={tab.icon} size={1.1} />
          <div>{tab.label}</div>
        </div>
      ))}
    </nav>
  );
};
