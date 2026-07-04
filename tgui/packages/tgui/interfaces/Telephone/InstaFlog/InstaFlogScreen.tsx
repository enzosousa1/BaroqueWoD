import type { ReactNode } from 'react';
import { Box, Stack } from 'tgui-core/components';

/** Clears the phone system navigation bar (height={3} in Telephone/index.tsx). */
const PHONE_NAV_CLEARANCE = 3;

const scrollAreaStyle = {
  scrollbarWidth: 'none' as const,
  msOverflowStyle: 'none' as const,
  minHeight: 0,
};

type InstaFlogScreenProps = {
  background?: string;
  header: ReactNode;
  footer?: ReactNode;
  /** Registration and other short forms: content hugs the header instead of stretching. */
  compact?: boolean;
  /** Centers children in the area between header and footer (e.g. compose). */
  centered?: boolean;
  /** Tall forms (registration): scroll from top, no flex-center clipping. */
  scrollForm?: boolean;
  /** Centers registration panel vertically without clipping. */
  centeredRegistration?: boolean;
  children: ReactNode;
};

const getScrollClass = (centered: boolean, scrollForm: boolean) => {
  if (scrollForm) {
    return 'InstaFlog__Scroll--form';
  }
  if (centered) {
    return 'InstaFlog__Scroll--centered';
  }
  return undefined;
};

const getContentClass = (centered: boolean, scrollForm: boolean) => {
  if (scrollForm) {
    return 'InstaFlog__Content InstaFlog__Content--form';
  }
  if (centered) {
    return 'InstaFlog__Content InstaFlog__Content--centered';
  }
  return 'InstaFlog__Content';
};

export const InstaFlogScreen = (props: InstaFlogScreenProps) => {
  const {
    background = '#dbc79a',
    header,
    footer,
    compact = false,
    centered = false,
    scrollForm = false,
    centeredRegistration = false,
    children,
  } = props;

  const isCenteredLayout = centered || centeredRegistration;
  const contentGrows = isCenteredLayout || scrollForm || !compact;

  return (
    <Stack vertical fill className="InstaFlog__App" style={{ background }}>
      <Stack.Item width="100%">{header}</Stack.Item>
      <Stack.Item
        grow={contentGrows}
        overflowY="auto"
        width="100%"
        mb={footer || centeredRegistration ? 0 : PHONE_NAV_CLEARANCE}
        className={
          centeredRegistration
            ? 'InstaFlog__Scroll--registration'
            : getScrollClass(centered, scrollForm)
        }
        style={scrollAreaStyle}
      >
        {centeredRegistration ? (
          <Box className="InstaFlog__Content InstaFlog__Content--centered-registration">
            <div
              className="InstaFlog__RegistrationSpacer InstaFlog__RegistrationSpacer--top"
              aria-hidden
            />
            {children}
            <div
              className="InstaFlog__RegistrationSpacer InstaFlog__RegistrationSpacer--bottom"
              aria-hidden
            />
          </Box>
        ) : (
          <Box
            className={getContentClass(centered, scrollForm)}
            width="100%"
            height={isCenteredLayout && !scrollForm ? '100%' : undefined}
            p={isCenteredLayout || scrollForm ? 0 : compact ? 0.75 : 1}
          >
            {children}
          </Box>
        )}
      </Stack.Item>
      {footer ? (
        <Stack.Item width="100%" pb={PHONE_NAV_CLEARANCE} style={{ flexShrink: 0 }}>
          {footer}
        </Stack.Item>
      ) : null}
    </Stack>
  );
};
