import type { CSSProperties } from 'react';

export const instaflogAppRoot: CSSProperties = {
  width: '100%',
  height: '100%',
  maxWidth: '100%',
  overflow: 'hidden',
  boxSizing: 'border-box',
};

export const instaflogScrollArea: CSSProperties = {
  flex: '1 1 auto',
  width: '100%',
  minHeight: 0,
  overflowX: 'hidden',
  overflowY: 'auto',
};

export const instaflogFullWidth: CSSProperties = {
  width: '100%',
  maxWidth: '100%',
  boxSizing: 'border-box',
};

export const instaflogChrome: CSSProperties = {
  background: 'linear-gradient(180deg, #f6e6c8 0%, #d9b88c 45%, #b8894f 100%)',
  borderBottom: '2px solid #8b5e2b',
  boxShadow: 'inset 0 1px 0 #fff8e8, 0 2px 4px rgba(0,0,0,0.35)',
};

export const instaflogPanel: CSSProperties = {
  background: 'linear-gradient(180deg, #fffdf6 0%, #f2e4cc 100%)',
  border: '2px solid #c9a56d',
  boxShadow: 'inset 0 2px 6px rgba(255,255,255,0.8), inset 0 -2px 5px rgba(120,80,30,0.15)',
};

export const instaflogInsetField: CSSProperties = {
  width: '100%',
  padding: '6px 8px',
  borderRadius: '6px',
  border: '2px inset #bda37a',
  background: 'linear-gradient(180deg, #fff 0%, #f0e2c8 100%)',
  boxShadow: 'inset 0 2px 4px rgba(0,0,0,0.12)',
  fontSize: '12px',
  boxSizing: 'border-box',
  color: '#3b2b16',
};

export const instaflogGlossButton = (
  tone: 'gold' | 'green' | 'gray' | 'pink' = 'gold',
  pressed = false,
): CSSProperties => {
  const palettes = {
    gold: ['#ffe7a8', '#e0b24d', '#9a6d1d'],
    green: ['#d8f5b8', '#7fbf3f', '#4a7a1d'],
    gray: ['#ececec', '#bdbdbd', '#8a8a8a'],
    pink: ['#ffd4f0', '#e878b8', '#a83278'],
  };
  const [top, mid, bottom] = palettes[tone];
  return {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '6px 10px',
    borderRadius: '8px',
    border: '2px solid #6d4a1f',
    background: `linear-gradient(180deg, ${top} 0%, ${mid} 55%, ${bottom} 100%)`,
    boxShadow: pressed
      ? 'inset 0 2px 4px rgba(0,0,0,0.35)'
      : 'inset 0 1px 0 rgba(255,255,255,0.7), 0 2px 3px rgba(0,0,0,0.35)',
    color: tone === 'gray' ? '#333' : '#2d1a05',
    fontWeight: 'bold',
    fontSize: '10px',
    cursor: 'pointer',
    textShadow: '0 1px 0 rgba(255,255,255,0.45)',
    transform: pressed ? 'translateY(1px)' : 'none',
    transition: 'transform 0.08s ease, box-shadow 0.08s ease',
    userSelect: 'none',
    whiteSpace: 'nowrap',
    flexShrink: 0,
  };
};

export const instaflogCard: CSSProperties = {
  background: 'linear-gradient(180deg, #fffefb 0%, #f5ebd4 100%)',
  border: '1px solid #d2b98d',
  borderRadius: '8px',
  boxShadow: '0 2px 4px rgba(80,50,20,0.18), inset 0 1px 0 #fff',
};

export const instaflogBottomNav: CSSProperties = {
  width: '100%',
  transform: 'translateY(64px)',
  boxSizing: 'border-box',
  background: 'linear-gradient(180deg, #fff4d6 0%, #d4a96a 55%, #9a6d2a 100%)',
  borderTop: '2px solid #7a5520',
  boxShadow: 'inset 0 1px 0 #fff8e0, 0 -2px 4px rgba(0,0,0,0.2)',
  padding: '18px 2px 3px',
  flexShrink: 0,
};

export const instaflogNavButton = (active = false): CSSProperties => ({
  flex: 1,
  textAlign: 'center',
  padding: '6px 2px',
  borderRadius: '10px',
  border: active ? '2px solid #6d3f10' : '2px solid transparent',
  background: active
    ? 'linear-gradient(180deg, #ffe8a0 0%, #d9a84a 100%)'
    : 'transparent',
  boxShadow: active
    ? 'inset 0 1px 0 rgba(255,255,255,0.6), 0 1px 3px rgba(0,0,0,0.2)'
    : 'none',
  color: '#3b2208',
  fontSize: '9px',
  fontWeight: 'bold',
  cursor: 'pointer',
  transition: 'background 0.15s ease, box-shadow 0.15s ease',
});

export const instaflogLogo: CSSProperties = {
  fontFamily: 'Tahoma, Verdana, sans-serif',
  fontSize: '15px',
  fontWeight: 'bold',
  letterSpacing: '0.5px',
  background: 'linear-gradient(180deg, #fff8d8 0%, #f0b84a 35%, #c87820 70%, #8a4a10 100%)',
  WebkitBackgroundClip: 'text',
  WebkitTextFillColor: 'transparent',
  textShadow: '0 2px 0 rgba(255,255,255,0.5), 0 3px 6px rgba(0,0,0,0.35)',
  filter: 'drop-shadow(0 1px 1px rgba(255,220,150,0.8))',
};

export const instaflogFadeIn: CSSProperties = {
  animation: 'instaflogFadeIn 0.2s ease',
};

export const instaflogSlideIn: CSSProperties = {
  animation: 'instaflogSlideIn 0.22s ease',
};
