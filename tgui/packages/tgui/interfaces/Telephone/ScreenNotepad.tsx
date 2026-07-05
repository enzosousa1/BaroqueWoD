// THIS IS A BAROQUE UI FILE
import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Icon, Stack } from 'tgui-core/components';
import type { Data, NavigableApps } from '.';

export const ScreenNotepad = (props: {
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { setApp } = props;
  const { act, data } = useBackend<Data>();
  const maxLength = data.notepad_max_length ?? 2000;
  const savedText = data.notepad_text ?? '';

  const [draft, setDraft] = useState(savedText);
  const [dirty, setDirty] = useState(false);

  useEffect(() => {
    setDraft(savedText);
    setDirty(false);
  }, [savedText]);

  const navigateHome = () => {
    act('keyboard_click');
    setApp(null);
  };

  const handleSave = () => {
    act('keyboard_click');
    act('notepad_save', { body: draft });
    setDirty(false);
  };

  const handleClear = () => {
    act('keyboard_click');
    act('notepad_clear');
    setDraft('');
    setDirty(false);
  };

  return (
    <Stack vertical fill backgroundColor="#fff9e8" textColor="#2f2414">
      <Stack.Item
        backgroundColor="#f0d98c"
        textColor="#3b2b16"
        style={{ borderBottom: '1px solid #c9b36a' }}
      >
        <Stack align="center" justify="space-between" px={1} py={0.75}>
          <Stack.Item>
            <div
              onClick={navigateHome}
              style={{
                display: 'flex',
                alignItems: 'center',
                padding: '4px 8px',
                backgroundColor: '#fff4cc',
                border: '1px solid #c9b36a',
                borderRadius: '4px',
                cursor: 'pointer',
                boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.6)',
              }}
            >
              <Icon name="chevron-left" mr={0.5} />
              <span style={{ fontSize: '12px', fontWeight: 700 }}>Home</span>
            </div>
          </Stack.Item>
          <Stack.Item>
            <Stack align="center">
              <Icon name="sticky-note" mr={0.5} />
              <span style={{ fontSize: '14px', fontWeight: 700 }}>Notepad</span>
            </Stack>
          </Stack.Item>
          <Stack.Item width="72px" />
        </Stack>
      </Stack.Item>

      <Stack.Item grow overflow="hidden" px={1} pt={1}>
        <textarea
          value={draft}
          maxLength={maxLength}
          placeholder="Write anything here..."
          onChange={(event) => {
            setDraft(event.target.value);
            setDirty(true);
          }}
          style={{
            width: '100%',
            height: '100%',
            minHeight: '180px',
            resize: 'none',
            boxSizing: 'border-box',
            border: '1px solid #d8c48a',
            borderRadius: '6px',
            padding: '8px',
            fontSize: '12px',
            lineHeight: 1.45,
            fontFamily: 'inherit',
            color: '#2f2414',
            background: '#fffdf4',
            boxShadow: 'inset 0 1px 3px rgba(0,0,0,0.08)',
          }}
        />
      </Stack.Item>

      <Stack.Item px={1} pb={8}>
        <Stack justify="space-between" align="center">
          <Stack.Item>
            <Box fontSize="10px" color="#7a6540">
              {draft.length}/{maxLength}
              {dirty ? ' · unsaved' : ''}
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item>
                <button
                  type="button"
                  onClick={handleClear}
                  style={{
                    padding: '6px 10px',
                    fontSize: '11px',
                    fontWeight: 600,
                    borderRadius: '4px',
                    border: '1px solid #c9b36a',
                    background: '#f5edd0',
                    color: '#5c4520',
                    cursor: 'pointer',
                  }}
                >
                  Clear
                </button>
              </Stack.Item>
              <Stack.Item ml={0.5}>
                <button
                  type="button"
                  onClick={handleSave}
                  style={{
                    padding: '6px 12px',
                    fontSize: '11px',
                    fontWeight: 700,
                    borderRadius: '4px',
                    border: '1px solid #8f6f2c',
                    background: dirty ? '#e8b84a' : '#f0d070',
                    color: '#3b2b16',
                    cursor: 'pointer',
                  }}
                >
                  Save
                </button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
