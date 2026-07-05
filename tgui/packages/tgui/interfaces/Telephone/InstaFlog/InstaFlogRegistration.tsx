import type { CSSProperties, ReactNode } from 'react';
import { useState } from 'react';
import { Stack } from 'tgui-core/components';
import type { InstaFlogAccount } from '..';
import { instaflogInsetField, instaflogPanel } from '../instaflogStyles';
import { GlossButton, InstaFlogAppHeader } from './InstaFlogComponents';
import { InstaFlogScreen } from './InstaFlogScreen';

type RegistrationProps = {
  initial?: InstaFlogAccount | null;
  isUpdate?: boolean;
  onBack: () => void;
  onSubmit: (fields: Record<string, string>) => void;
  onClickSound: () => void;
};

const FieldLabel = (props: { children: ReactNode }) => (
  <div className="InstaFlog__FieldLabel">{props.children}</div>
);

const FieldError = (props: { children: ReactNode }) => (
  <div className="InstaFlog__FieldError">{props.children}</div>
);

export const InstaFlogRegistration = (props: RegistrationProps) => {
  const { initial, isUpdate, onBack, onSubmit, onClickSound } = props;
  const [displayName, setDisplayName] = useState(initial?.display_name ?? '');
  const [bio, setBio] = useState(initial?.bio ?? '');
  const [city, setCity] = useState(initial?.city ?? '');
  const [profilePhotoUrl, setProfilePhotoUrl] = useState(
    initial?.profile_photo_url ?? '',
  );
  const [urlError, setUrlError] = useState(false);

  const handleSubmit = () => {
    if (!displayName.trim()) {
      return;
    }
    const trimmedUrl = profilePhotoUrl.trim();
    if (trimmedUrl && !/^https?:\/\//i.test(trimmedUrl)) {
      setUrlError(true);
      return;
    }
    setUrlError(false);
    onClickSound();
    onSubmit({
      display_name: displayName.trim(),
      bio,
      city,
      profile_photo_url: profilePhotoUrl,
    });
  };

  const compactField: CSSProperties = {
    ...instaflogInsetField,
    padding: '4px 6px',
    fontSize: '10px',
    lineHeight: 1.4,
    minHeight: '22px',
  };

  return (
    <InstaFlogScreen
      background="#e8d2a5"
      header={
        <InstaFlogAppHeader
          minimal
          title={isUpdate ? 'Editar perfil' : 'Cadastro'}
          onBack={() => {
            onClickSound();
            onBack();
          }}
        />
      }
    >
      <div
        className="InstaFlog__Panel InstaFlog__Panel--registration"
        style={{
          ...instaflogPanel,
          padding: '6px 8px',
          borderRadius: '8px',
        }}
      >
        <div className="InstaFlog__RegistrationForm">
          {initial?.username && (
            <div>
              <FieldLabel>Usuário</FieldLabel>
              <input
                className="InstaFlog__FormField"
                style={{ ...compactField, opacity: 0.75 }}
                value={`@${initial.username}`}
                disabled
                readOnly
              />
            </div>
          )}

          <div>
            <FieldLabel>Nome de exibição *</FieldLabel>
            <input
              className="InstaFlog__FormField"
              style={compactField}
              value={displayName}
              maxLength={24}
              placeholder="Como aparece no feed"
              onChange={(event) => setDisplayName(event.target.value)}
            />
          </div>

          <div>
            <FieldLabel>Biografia</FieldLabel>
            <input
              className="InstaFlog__FormField"
              style={compactField}
              value={bio}
              maxLength={140}
              placeholder="Opcional"
              onChange={(event) => setBio(event.target.value)}
            />
          </div>

          <div>
            <FieldLabel>Cidade</FieldLabel>
            <input
              className="InstaFlog__FormField"
              style={compactField}
              value={city}
              maxLength={32}
              placeholder="Opcional"
              onChange={(event) => setCity(event.target.value)}
            />
          </div>

          <div>
            <FieldLabel>Foto de perfil (URL)</FieldLabel>
            <input
              className="InstaFlog__FormField"
              style={compactField}
              value={profilePhotoUrl}
              maxLength={512}
              placeholder="https://... (opcional)"
              onChange={(event) => {
                setUrlError(false);
                setProfilePhotoUrl(event.target.value);
              }}
            />
            {urlError && (
              <FieldError>URL inválida. Use http:// ou https://.</FieldError>
            )}
          </div>

          <Stack mt={0.5} justify="center">
            <GlossButton tone="green" onClick={handleSubmit}>
              {isUpdate ? 'Salvar perfil' : 'Criar conta'}
            </GlossButton>
          </Stack>
        </div>
      </div>
    </InstaFlogScreen>
  );
};
