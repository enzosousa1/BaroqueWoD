import { useState } from 'react';
import { Box } from 'tgui-core/components';
import type { PhonePhoto } from '..';
import { instaflogInsetField, instaflogPanel, instaflogSlideIn } from '../instaflogStyles';
import { GlossButton } from './InstaFlogComponents';

type ComposeProps = {
  photos: PhonePhoto[];
  onSubmit: (body: string, galleryPhotoId: number | null) => void;
  onCancel: () => void;
  onClickSound: () => void;
};

export const InstaFlogCompose = (props: ComposeProps) => {
  const { photos, onSubmit, onCancel, onClickSound } = props;
  const [body, setBody] = useState('');
  const [selectedPhotoId, setSelectedPhotoId] = useState<number | null>(null);
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = () => {
    if (!body.trim()) {
      return;
    }
    onClickSound();
    onSubmit(body.trim(), selectedPhotoId);
    setSubmitted(true);
    setBody('');
    setSelectedPhotoId(null);
    setTimeout(() => setSubmitted(false), 1200);
  };

  return (
    <div
      className="InstaFlog__Panel InstaFlog__Panel--compose"
      style={{ ...instaflogPanel, padding: '10px', borderRadius: '10px', ...instaflogSlideIn }}
    >
      <Box bold fontSize="12px" color="#4a2f0e" mb={1}>
        Nova postagem
      </Box>

      <textarea
        className="InstaFlog__FormField"
        placeholder="O que você está fazendo agora?"
        value={body}
        onChange={(event) => setBody(event.target.value.slice(0, 280))}
        maxLength={280}
        style={{
          ...instaflogInsetField,
          minHeight: '72px',
          resize: 'vertical',
        }}
      />
      <Box fontSize="9px" color="#7a5528" textAlign="right" mt={0.5}>
        {body.length}/280
      </Box>

      <Box mt={1} mb={0.5} bold fontSize="10px" color="#6d4a1f">
        Imagem da galeria (opcional)
      </Box>

      {photos.length === 0 ? (
        <Box fontSize="10px" color="#8a6a3c" mb={1}>
          Nenhuma foto na galeria. Use a Câmera para tirar fotos.
        </Box>
      ) : (
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(4, 1fr)',
            gap: '4px',
            maxHeight: '140px',
            overflowY: 'auto',
            marginBottom: '8px',
            width: '100%',
          }}
        >
          {photos.map((photo) => (
            <div
              key={photo.id}
              onClick={() => {
                onClickSound();
                setSelectedPhotoId(selectedPhotoId === photo.id ? null : photo.id);
              }}
              style={{
                aspectRatio: '1',
                borderRadius: '4px',
                border:
                  selectedPhotoId === photo.id
                    ? '3px solid #e878b8'
                    : '2px solid #c9a56d',
                boxShadow:
                  selectedPhotoId === photo.id
                    ? '0 0 6px rgba(232,120,184,0.6)'
                    : '0 1px 2px rgba(0,0,0,0.2)',
                overflow: 'hidden',
                cursor: 'pointer',
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
                    display: 'block',
                  }}
                />
              ) : (
                <Box
                  width="100%"
                  height="100%"
                  backgroundColor="#d2b98d"
                  textAlign="center"
                  pt={1.5}
                  fontSize="9px"
                >
                  ?
                </Box>
              )}
            </div>
          ))}
        </div>
      )}

      <div className="InstaFlog__ActionRow">
        {submitted ? (
          <Box color="#3f6f18" fontSize="11px" bold>
            Flog publicado!
          </Box>
        ) : (
          <>
            <GlossButton tone="green" onClick={handleSubmit}>
              Publicar
            </GlossButton>
            <GlossButton tone="gray" onClick={onCancel}>
              Cancelar
            </GlossButton>
          </>
        )}
      </div>
    </div>
  );
};
