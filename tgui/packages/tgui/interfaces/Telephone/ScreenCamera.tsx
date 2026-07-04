// THIS IS A BAROQUE UI FILE
import { useEffect } from 'react';
import { Box, Icon, Stack } from 'tgui-core/components';
import { Data, NavigableApps } from '.';
import { useBackend } from 'tgui/backend';

export const ScreenCamera = (props: {
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { setApp } = props;
  const { act, data } = useBackend<Data>();

  useEffect(() => {
    act('camera_open');
    return () => {
      act('camera_close');
    };
  }, [act]);

  const navigateTo = (app: NavigableApps) => {
    act('keyboard_click');
    setApp(app);
  };

  const takePhoto = () => {
    act('keyboard_click');
    act('take_photo');
  };

  return (
    <Stack vertical fill backgroundColor="#000000">
      <Stack.Item grow position="relative">
        <Stack fill vertical align="center" justify="center">
          <Stack.Item opacity={0.35}>
            <Icon name="expand" size={5} color="#ffffff" />
          </Stack.Item>
          <Stack.Item>
            <Box
              textAlign="center"
              color="#aaaaaa"
              fontSize="11px"
              px={2}
              lineHeight={1.4}
            >
              Use the shutter or right-click something in the world to take a
              photo.
            </Box>
          </Stack.Item>
          {!!data.camera_mode && (
            <Stack.Item mt={1}>
              <Box color="#4cd964" fontSize="10px" bold>
                Camera active
              </Box>
            </Stack.Item>
          )}
        </Stack>
      </Stack.Item>

      <Stack.Item
        backgroundColor="#000000"
        p={1}
        height="64px"
        style={{ borderTop: '1px solid #222' }}
      >
        <Stack fill align="center" justify="space-between">
          <Stack.Item width="40px" height="40px" ml={1}>
            <div
              onClick={() => setApp(null)}
              style={{
                width: '100%',
                height: '100%',
                backgroundColor: '#111',
                border: '1px solid #eeeeee',
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                boxSizing: 'border-box',
              }}
            >
              <Icon name="arrow-left" color="#ffffff" size={1} />
            </div>
          </Stack.Item>

          <Stack.Item>
            <div
              onClick={takePhoto}
              style={{
                width: '76px',
                height: '36px',
                backgroundColor: '#b5b5b5',
                borderRadius: '18px',
                border: '2px solid #ffffff',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                cursor: 'pointer',
                boxShadow:
                  'inset 0 2px 4px rgba(255,255,255,0.6), inset 0 -2px 4px rgba(0,0,0,0.3)',
              }}
            >
              <Icon name="camera" color="#222222" size={1.2} />
            </div>
          </Stack.Item>

          <Stack.Item width="40px" height="40px" mr={1}>
            <div
              onClick={() => navigateTo(NavigableApps.Gallery)}
              style={{
                width: '100%',
                height: '100%',
                backgroundColor: '#111',
                border: '1px solid #eeeeee',
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                boxSizing: 'border-box',
              }}
            >
              <Icon name="image" color="#ffffff" size={1} />
            </div>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};