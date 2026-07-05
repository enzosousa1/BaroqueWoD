// BAROQUE UI FILE

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Button, Section, TextArea, LabeledList, NoticeBox } from 'tgui-core/components';
import { useState } from 'react';

type CityStats = {
  population: number;
  townhall_staff: number;
  city_services: number;
  round_time: number;
};

type MayorConsoleData = {
  last_announcement: string;
  last_announcer: string;
  mayor_name: string;
  on_cooldown: number;
  city_stats: CityStats;
};

export const MayorConsole = () => {
  const { act, data } = useBackend<MayorConsoleData>();
  const {
    last_announcement = 'No city announcements have been issued this term.',
    last_announcer = 'N/A',
    mayor_name = 'Unknown',
    on_cooldown = 0,
    city_stats = {
      population: 0,
      townhall_staff: 0,
      city_services: 0,
      round_time: 0,
    },
  } = data;

  const [draft, setDraft] = useState('');

  return (
    <Window title="Mayor's Console" width={520} height={620}>
      <Window.Content scrollable>
        <Section title="City Status">
          <LabeledList>
            <LabeledList.Item label="Mayor">{mayor_name}</LabeledList.Item>
            <LabeledList.Item label="Population">
              {city_stats.population}
            </LabeledList.Item>
            <LabeledList.Item label="Town Hall Staff">
              {city_stats.townhall_staff}
            </LabeledList.Item>
            <LabeledList.Item label="City Services">
              {city_stats.city_services}
            </LabeledList.Item>
            <LabeledList.Item label="Round Time">
              {city_stats.round_time} min
            </LabeledList.Item>
          </LabeledList>
        </Section>

        <Section title="Latest Bulletin">
          <NoticeBox>
            <b>{last_announcer}</b>
            <br />
            {last_announcement}
          </NoticeBox>
        </Section>

        <Section title="Issue Announcement">
          {on_cooldown > 0 && (
            <NoticeBox color="orange">
              Please wait {Math.ceil(on_cooldown / 10)}s before sending another
              announcement.
            </NoticeBox>
          )}
          <TextArea
            fluid
            height="120px"
            value={draft}
            onChange={setDraft}
            placeholder="Write a public announcement for Santa Augustina..."
          />
          <Button
            mt={1}
            icon="bullhorn"
            disabled={!draft.length || on_cooldown > 0}
            onClick={() => {
              act('send_announcement', { message: draft });
              setDraft('');
            }}
          >
            Broadcast Announcement
          </Button>
          <Button
            ml={1}
            mt={1}
            icon="triangle-exclamation"
            color="bad"
            disabled={on_cooldown > 0}
            onClick={() => act('send_emergency_notice')}
          >
            Emergency Notice
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};