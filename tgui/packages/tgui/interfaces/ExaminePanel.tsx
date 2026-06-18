// THIS IS A DARKPACK UI FILE
import { useMemo, useState } from 'react'; // NOCTURNE EDIT - ORIGINAL: import { useState } from 'react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Section, Stack, Box, Button } from 'tgui-core/components'; // NOCTURNE EDIT - ORIGINAL: import { Section, Stack, Tabs, Box, } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { Window } from '../layouts';

type ExamineData = {
  character_name: string;
  obscured: BooleanLike;
  flavor_text: string;
  flavor_text_nsfw: string;
  headshot: string,
  ooc_notes: string;
  character_notes: string;
  nsfw_content: BooleanLike;
}

function formatURLs(text: string) {
  if (!text) return;
  const parts: React.ReactNode[] = [];
  const regex = /https?:\/\/[^\s/$.?#].[^\s]*/gi;
  let lastIndex = 0;

  text.replace(regex, (url: string, index: number) => {
    parts.push(text.substring(lastIndex, index));
    parts.push(
      <a
        style={{
          color: '#0591e3',
          textDecoration: 'none',
        }}
        href={url}
        target="_blank"
        rel="noopener noreferrer"
      >
        {url}
      </a>,
    );
    lastIndex = index + url.length;
    return url;
  });

  parts.push(text.substring(lastIndex));
  return <div>{parts}</div>;
};

export const ExaminePanel = (props) => {
  const [tabIndex, setTabIndex] = useState(1);
  const [lowerTabIndex, setLowerTabIndex] = useState(1);
  const { act, data } = useBackend<ExamineData>();
  const {
    character_name,
    obscured,
    flavor_text,
    flavor_text_nsfw,
    headshot,
    ooc_notes,
    character_notes,
    nsfw_content,
  } = data;

  // NOCTURNE ADDITION START
  const [oocNotesIndex, setOocNotesIndex] = useState('SFW');
  const [flavorTextIndex, setFlavorTextIndex] = useState('SFW');

  const flavorHTML = useMemo(() => ({
    __html: `<span className='Chat'>${flavor_text}</span>`,
  }), [flavor_text]);

  const nsfwHTML = useMemo(() => ({
    __html: `<span className='Chat'>${flavor_text_nsfw}</span>`,
  }), [flavor_text_nsfw]);

  const oocHTML = useMemo(() => ({
    __html: `<span className='Chat'>${character_notes}</span>`,
  }), [character_notes]);

  const oocnsfwHTML = useMemo(() => ({
    __html: `<span className='Chat'>${ooc_notes}</span>`,
  }), [ooc_notes]);
  // NOCTURNE ADDITION END

  return (
    <Window
      title={`${character_name}'s Examine Panel`}
      width={900}
      height={670}
    >
      <Window.Content>
        {/* NOCTURNE REMOVAL START
        <Stack fill>
          <Stack.Item>
            <Section title="Headshot">
              <img
                src={resolveAsset(headshot)}
                height="250px"
                width="250px"
              />
            </Section>
          </Stack.Item>
          <Stack.Item grow mb={1}>
            <Stack vertical fill>
              <Tabs fluid>
                <Tabs.Tab
                  selected={tabIndex === 1}
                  onClick={() => setTabIndex(1)}
                >
                Flavor Text
                </Tabs.Tab>
                {nsfw_content ?
                <Tabs.Tab
                  selected={tabIndex === 2}
                  onClick={() => setTabIndex(2)}
                >
                Flavor Text (NSFW)
                </Tabs.Tab>
                : null}
              </Tabs>
              <Section
                style={{
                overflowY: 'scroll',
                height: '300px',
                fontSize: '14px',
                lineHeight: 1.7,
                }}
                preserveWhitespace
              >
                {formatURLs(tabIndex === 1 ? flavor_text : flavor_text_nsfw)}
              </Section>
              <Tabs fluid>
                <Tabs.Tab
                  selected={lowerTabIndex === 1}
                  onClick={() => setLowerTabIndex(1)}
                >
                Character Notes
                </Tabs.Tab>
                {nsfw_content ?
                <Tabs.Tab
                  selected={lowerTabIndex === 2}
                  onClick={() => setLowerTabIndex(2)}
                >
                OOC Notes (NSFW)
                </Tabs.Tab>
                : null}
              </Tabs>
              <Box
              style={{
              overflowY: 'scroll',
              fontSize: '14px',
              height: '300px',
              lineHeight: 1.7,
              }}
              preserveWhitespace
              inline
              >
                <Section>{formatURLs(lowerTabIndex === 1 ? character_notes : ooc_notes)}</Section>
              </Box>
            </Stack>
          </Stack.Item>
        </Stack>
        NOCTURNE REMOVAL END */}

        {/* NOCTURNE ADDITION START*/}
        <Stack fill>
          <Stack fill vertical>
            <Stack.Item>
              <Section title="Headshot">
                <img
                  src={resolveAsset(headshot)}
                  height="300px"
                  width="300px"
                />
              </Section>
            </Stack.Item>

            <Stack.Item grow>
              <Stack fill>
                <Stack.Item grow>
                  <Section
                    scrollable
                    fill
                    title="OOC Notes"
                    preserveWhitespace
                    buttons={nsfw_content ?
                      <>
                        <Button
                          selected={oocNotesIndex === 'SFW'}
                          bold={oocNotesIndex === 'SFW'}
                          onClick={() => setOocNotesIndex('SFW')}
                          textAlign="center"
                          minWidth="60px"
                        >
                          SFW
                        </Button>
                        <Button
                          selected={oocNotesIndex === 'NSFW'}
                          disabled={!ooc_notes}
                          bold={oocNotesIndex === 'NSFW'}
                          onClick={() => setOocNotesIndex('NSFW')}
                          textAlign="center"
                          minWidth="60px"
                        >
                          NSFW
                        </Button>
                      </>
                    : null}
                  >
                    {oocNotesIndex === 'SFW' && (
                      <Box
                      dangerouslySetInnerHTML={{
                        __html: character_notes
                        ? `<span class='Chat'>${character_notes}</span>`
                        : "<i>No OOC notes provided.</i>",
                      }}
                      />
                    )}
                    {oocNotesIndex === 'NSFW' && (
                      <Box
                      dangerouslySetInnerHTML={oocnsfwHTML}
                      />
                    )}
                  </Section>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
          <Stack.Item grow mb={1}>
            <Stack vertical fill>
              <Section
                scrollable
                fill
                title="Flavor Text"
                preserveWhitespace
                buttons={nsfw_content ?
                  <>
                    <Button
                      selected={flavorTextIndex === 'SFW'}
                      bold={flavorTextIndex === 'SFW'}
                      onClick={() => setFlavorTextIndex('SFW')}
                      textAlign="center"
                      minWidth="60px"
                    >
                      SFW
                    </Button>
                    <Button
                      selected={flavorTextIndex === 'NSFW'}
                      disabled={!flavor_text_nsfw}
                      bold={flavorTextIndex === 'NSFW'}
                      onClick={() => setFlavorTextIndex('NSFW')}
                      textAlign="center"
                      minWidth="60px"
                    >
                      NSFW
                    </Button>
                  </>
                : null}
              >
                {flavorTextIndex === 'SFW' && (
                <Box
                  dangerouslySetInnerHTML={{
                    __html: flavor_text
                    ? `<span class='Chat'>${flavor_text}</span>`
                    : "<i>No flavor text provided.</i>",
                  }}
                />
                )}
                {flavorTextIndex === 'NSFW' && (
                  <Box
                    dangerouslySetInnerHTML={nsfwHTML}
                  />
                )}
              </Section>
            </Stack>
          </Stack.Item>
        </Stack>
        {/* NOCTURNE ADDITION END */}
      </Window.Content>
    </Window>
  );
};
