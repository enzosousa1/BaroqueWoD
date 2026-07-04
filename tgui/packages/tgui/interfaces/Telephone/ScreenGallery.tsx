// THIS IS A BAROQUE UI FILE
import { useEffect } from 'react';
import { Box, Icon, Image, Stack } from 'tgui-core/components';
import { Data, NavigableApps } from '.';
import { useBackend } from 'tgui/backend';

export const ScreenGallery = (props: {
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { setApp } = props;
  const { act, data } = useBackend<Data>();
  const photos = data.photos ?? [];
  const preview = data.viewing_photo;

  useEffect(() => {
    return () => {
      act('close_photo');
    };
  }, [act]);

  const navigateTo = (app: NavigableApps | null) => {
    act('keyboard_click');
    setApp(app);
  };

  const openPhoto = (id: number) => {
    act('keyboard_click');
    act('view_photo', { id });
  };

  const closePreview = () => {
    act('keyboard_click');
    act('close_photo');
  };

  if (preview) {
    return (
      <Stack vertical fill backgroundColor="#000000">
        <Stack.Item
          backgroundColor="#1a1a1a"
          height="44px"
          style={{ borderBottom: '1px solid #000' }}
        >
          <Stack fill align="center" justify="space-between" px={1}>
            <Stack.Item>
              <div
                onClick={closePreview}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  padding: '4px 8px',
                  backgroundColor: '#333',
                  border: '1px solid #555',
                  borderRadius: '4px',
                  cursor: 'pointer',
                  boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.2)',
                }}
              >
                <Icon name="chevron-left" color="#ffffff" mr={0.5} />
                <span
                  style={{
                    color: '#ffffff',
                    fontSize: '12px',
                    fontWeight: 'bold',
                  }}
                >
                  Galeria
                </span>
              </div>
            </Stack.Item>
            <Stack.Item>
              <span
                style={{ color: '#ffffff', fontSize: '14px', fontWeight: 'bold' }}
              >
                {preview.name}
              </span>
            </Stack.Item>
            <Stack.Item width="65px" />
          </Stack>
        </Stack.Item>

        <Stack.Item
          grow
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            overflow: 'hidden',
            padding: '8px',
          }}
        >
          <Image
            src={`data:image/jpeg;base64,${preview.image}`}
            style={{
              maxWidth: '100%',
              maxHeight: '100%',
              imageRendering: 'pixelated',
            }}
          />
        </Stack.Item>

        <Stack.Item
          backgroundColor="#111111"
          p={1}
          style={{ borderTop: '1px solid #222' }}
        >
          <Box color="#cccccc" fontSize="10px" mb={0.5}>
            {preview.time}
          </Box>
          <Box
            color="#888888"
            fontSize="9px"
            style={{ maxHeight: '72px', overflowY: 'auto' }}
          >
            {preview.desc}
          </Box>
        </Stack.Item>
      </Stack>
    );
  }

  return (
    <Stack vertical fill backgroundColor="#000000">
      <Stack.Item
        backgroundColor="#1a1a1a"
        height="44px"
        style={{ borderBottom: '1px solid #000' }}
      >
        <Stack fill align="center" justify="space-between" px={1}>
          <Stack.Item>
            <div
              onClick={() => navigateTo(null)}
              style={{
                display: 'flex',
                alignItems: 'center',
                padding: '4px 8px',
                backgroundColor: '#333',
                border: '1px solid #555',
                borderRadius: '4px',
                cursor: 'pointer',
                boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.2)',
              }}
            >
              <Icon name="chevron-left" color="#ffffff" mr={0.5} />
              <span
                style={{ color: '#ffffff', fontSize: '12px', fontWeight: 'bold' }}
              >
                Home
              </span>
            </div>
          </Stack.Item>
          <Stack.Item>
            <span
              style={{ color: '#ffffff', fontSize: '16px', fontWeight: 'bold' }}
            >
              Rolo da Câmera
            </span>
          </Stack.Item>
          <Stack.Item width="65px" />
        </Stack>
      </Stack.Item>

      <Stack.Item grow style={{ overflowY: 'auto' }}>
        {photos.length === 0 ? (
          <Stack fill align="center" justify="center">
            <Stack.Item>
              <Box color="#666666" fontSize="12px" textAlign="center" px={2}>
                No photos yet. Open the Camera app to take some.
              </Box>
            </Stack.Item>
          </Stack>
        ) : (
          <div
            style={{
              display: 'flex',
              flexWrap: 'wrap',
              padding: '2px',
              gap: '2px',
            }}
          >
            {photos.map((photo) => (
              <div
                key={photo.id}
                onClick={() => openPhoto(photo.id)}
                style={{
                  width: 'calc(33.33% - 2px)',
                  aspectRatio: '1 / 1',
                  backgroundColor: '#222222',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  cursor: 'pointer',
                  overflow: 'hidden',
                }}
              >
                {photo.thumbnail ? (
                  <img
                    src={`data:image/jpeg;base64,${photo.thumbnail}`}
                    alt={photo.name}
                    style={{
                      width: '100%',
                      height: '100%',
                      objectFit: 'cover',
                      imageRendering: 'pixelated',
                    }}
                  />
                ) : (
                  <Icon name="image" color="#444444" size={2} />
                )}
              </div>
            ))}
          </div>
        )}
      </Stack.Item>

      {/* Barra Inferior Corrigida */}
    <Stack.Item
    backgroundColor="#111111"
    height="96px" // aumenta um pouco a altura
    style={{
        borderTop: '1px solid #222',
        paddingBottom: '10px', // sobe os ícones
    }}
>
    <Stack fill align="center" justify="space-around">
    {/* Botão Álbuns */}
    <div
      style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        cursor: 'pointer',
      }}
    >
      <Icon name="images" color="#ffffff" size={1.4} />
      <span
        style={{
          color: '#ffffff',
          fontSize: '10px',
          marginTop: '2px',
        }}
      >
        Álbuns
      </span>
    </div>

    {/* Botão Câmera */}
    <div
      onClick={() => navigateTo(NavigableApps.Camera)}
      style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        opacity: 0.5,
        cursor: 'pointer',
      }}
    >
      <Icon name="camera" color="#ffffff" size={1.2} />
      <span
        style={{
          color: '#ffffff',
          fontSize: '10px',
          marginTop: '2px',
        }}
      >
        Câmera
      </span>
    </div>
    </Stack>
        </Stack.Item>
        </Stack>
    );
};
