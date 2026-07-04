// THIS IS A DARKPACK UI FILE
import type React from 'react';
import { useBackend, useSharedState } from 'tgui/backend';
import { useMemo, memo } from 'react';
import { Window } from 'tgui/layouts';
import { Box, Icon, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { ScreenBackgrounds } from './ScreenBackgrounds';
import { ScreenBrowser } from './ScreenBrowser';
import { ScreenContacts } from './ScreenContacts';
import { ScreenHome } from './ScreenHome';
import { ScreenCalling, ScreenInCall } from './ScreenInCall';
import { ScreenMessages } from './ScreenMessages';
import { ScreenPhone } from './ScreenPhone';
import { ScreenCamera } from './ScreenCamera';
import { ScreenInstaFlog } from './ScreenInstaFlog';
import { ScreenRecents } from './ScreenRecents';
import { ScreenSettings } from './ScreenSettings';
import { ScreenSoundSettings } from './ScreenSoundSettings';
import { ScreenGallery } from './ScreenGallery';

export type Contact = {
  name: string;
  number: string;
};

export type PhoneHistoryEntry = {
  type: string;
  type_tooltip: string;
  name: string;
  number: string;
  time: string;
};

export type Comment = {
  body: string;
  author: string;
  time_stamp: string;
};

export type Message = {
  body: string;
  caption: string;
  author: string;
  time_stamp: string;
  comments: Comment[];
};

export type NewscasterChannel = {
  censored: BooleanLike;
  messages: Message[];
};

export type NewscasterChannelEntry = {
  name: string;
  censored: BooleanLike;
  ref: string;
};

export type ConversationMessage = {
  message_text: string;
  is_outgoing: BooleanLike;
  time: string;
};

export type Conversation = {
  number: string;
  contact_name: string;
  last_timestamp: number;
  last_message_text: string;
};

export type PhonePhoto = {
  id: number;
  name: string;
  time: string;
  thumbnail: string | null;
};

export type PhonePhotoPreview = {
  id: number;
  name: string;
  desc: string;
  time: string;
  image: string;
};

export type InstaFlogAccount = {
  username: string;
  display_name: string;
  bio: string;
  city: string;
  profile_photo_url: string;
  profile_photo_usable?: BooleanLike;
};

export type InstaFlogProfile = InstaFlogAccount & {
  post_count?: number;
};

export type InstaFlogComment = {
  body: string;
  username: string;
  display_name: string;
  date: string;
  time: string;
};

export type InstaFlogPost = {
  post_id: number;
  body: string;
  date: string;
  time: string;
  timestamp?: number;
  username: string;
  display_name: string;
  profile_photo_url: string;
  profile_photo_usable?: BooleanLike;
  city: string;
  image?: string;
  like_count?: number;
  liked_by_me?: BooleanLike;
  can_delete?: BooleanLike;
  comments?: InstaFlogComment[];
};

export type Data = {
  phone_calling: BooleanLike;
  phone_in_call: BooleanLike;
  phone_ringing: BooleanLike;
  my_number: string;
  choosed_number: string;
  calling_user?: string;
  ringer: BooleanLike;
  vibration: BooleanLike;
  speaker_mode: BooleanLike;
  muted: BooleanLike;
  time: string;
  date: string;
  background_url?: string;
  custom_background?: string;

  published_numbers: Contact[];
  sim_published: BooleanLike;
  our_contacts: Contact[];
  our_blocked_contacts: Contact[];

  phone_history: PhoneHistoryEntry[];

  newscaster_channels: NewscasterChannelEntry[];
  viewing_channel: null | NewscasterChannel;

  conversations: Conversation[];
  current_conversation_messages: ConversationMessage[];

  photos?: PhonePhoto[];
  camera_mode?: BooleanLike;
  viewing_photo?: PhonePhotoPreview | null;

  instaflog_registered?: BooleanLike;
  instaflog_account?: InstaFlogAccount | null;
  instaflog_posts?: InstaFlogPost[];
  instaflog_profiles?: Record<string, InstaFlogProfile>;
  show_instaflog_registration?: BooleanLike;
  is_admin?: BooleanLike;
};

export enum NavigableApps {
  Browser,
  Phone,
  Recents,
  Contacts,
  Messages,
  IRC,
  Camera,
  Gallery,
  Backgrounds,
  Settings,
  SoundSettings,
  InstaFlog,
}

const PhysicalScreen = memo((props: {
  app: NavigableApps | null;
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
  phoneCalling: boolean;
  phoneInCall: boolean;
  phoneRinging: boolean;
}) => {
  const { app, setApp, phoneCalling, phoneInCall, phoneRinging } = props;

  const [enteredNumber, setEnteredNumber] = useSharedState('enteredNumber', '');

  const browserComponent = useMemo(() => {
    if (app === NavigableApps.Browser) {
      return <ScreenBrowser setApp={setApp} />;
    }
    return null;
  }, [app, setApp]);

  const screenContent = useMemo(() => {
    if (phoneCalling) {
      return <ScreenCalling />;
    } else if (phoneInCall || phoneRinging) {
      return <ScreenInCall />;
    }

    if (browserComponent) {
      return browserComponent;
    }

    switch (app) {
      case NavigableApps.Phone:
        return (
          <ScreenPhone
            enteredNumber={enteredNumber}
            setEnteredNumber={setEnteredNumber}
            setApp={setApp}
          />
        );
      case NavigableApps.Contacts:
        return (
          <ScreenContacts
            enteredNumber={enteredNumber}
            setEnteredNumber={setEnteredNumber}
            setApp={setApp}
          />
        );
      case NavigableApps.Recents:
        return (
          <ScreenRecents
            enteredNumber={enteredNumber}
            setEnteredNumber={setEnteredNumber}
            setApp={setApp}
          />
        );
      case NavigableApps.Messages:
        return (
          <ScreenMessages
            enteredNumber={enteredNumber}
            setEnteredNumber={setEnteredNumber}
            setApp={setApp}
          />
        );
      case NavigableApps.Backgrounds:
        return <ScreenBackgrounds setApp={setApp} />;
      case NavigableApps.Camera:
        return <ScreenCamera setApp={setApp} />;
      case NavigableApps.Gallery:
        return <ScreenGallery setApp={setApp} />;
      case NavigableApps.Settings:
        return <ScreenSettings setApp={setApp} />;
      case NavigableApps.SoundSettings:
        return <ScreenSoundSettings setApp={setApp} />;
      case NavigableApps.InstaFlog:
        return <ScreenInstaFlog setApp={setApp} />;
      default:
        return <ScreenHome setApp={setApp} />;
    }
  }, [app, setApp, phoneCalling, phoneInCall, phoneRinging, browserComponent, enteredNumber, setEnteredNumber]);

  return screenContent;
});

const NavigationBar = memo((props: {
  app: NavigableApps | null;
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
  act: any;
}) => {
  const { app, setApp, act } = props;

  let textColor = '#fff';
  if (
    app === NavigableApps.Browser ||
    app === NavigableApps.Phone ||
    app === NavigableApps.Contacts ||
    app === NavigableApps.Recents ||
    app === NavigableApps.Messages ||
    app === NavigableApps.IRC ||
    app === NavigableApps.InstaFlog
  ) {
    textColor = '#000';
  }

  let backgroundColor: string | null = null;
  if (
    app === NavigableApps.Browser ||
    app === NavigableApps.Phone ||
    app === NavigableApps.Contacts ||
    app === NavigableApps.Recents ||
    app === NavigableApps.Messages ||
    app === NavigableApps.IRC ||
    app === NavigableApps.InstaFlog
  ) {
    backgroundColor = '#0004';
  }

  return (
    <Box position="fixed" bottom={0} left={0} right={0} height={3} style={{ zIndex: 100 }}>
      <Stack
        fill
        textColor={textColor}
        backgroundColor={backgroundColor}
        align="center"
        justify="space-around"
      >
        <Stack.Item width={8} height="100%">
          <Stack align="center" justify="center" fill>
            <Stack.Item>
              <Icon name="bars" size={1.5} />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item
          onClick={() => {
            act('viewing_newscaster_channel', { ref: null });
            setApp(null);
          }}
          className="Telephone__HomeButton"
          width={8}
          height="100%"
        >
          <Stack align="center" justify="center" fill>
            <Stack.Item>
              <Icon name="square-o" size={1.5} />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item
          onClick={() => {
            act('viewing_newscaster_channel', { ref: null });
            setApp(null);
          }}
          className="Telephone__HomeButton"
          width={8}
          height="100%"
        >
          <Stack align="center" justify="center" fill>
            <Stack.Item>
              <Icon name="chevron-left" size={1.5} />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );
});

export const Telephone = (props) => {
  const { act, data } = useBackend<Data>();
  const [app, setApp] = useSharedState<NavigableApps | null>(
    'telephone_state',
    null,
  );

  return (
    <Window width={285} height={530}>
      <Window.Content fitted>
        <PhysicalScreen
          app={app}
          setApp={setApp}
          phoneCalling={!!data.phone_calling}
          phoneInCall={!!data.phone_in_call}
          phoneRinging={!!data.phone_ringing}
        />
        <NavigationBar app={app} setApp={setApp} act={act} />
      </Window.Content>
    </Window>
  );
};
