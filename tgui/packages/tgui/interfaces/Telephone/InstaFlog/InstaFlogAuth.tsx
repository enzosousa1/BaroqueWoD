import type { CSSProperties, ReactNode } from 'react';
import { useState } from 'react';
import { Stack } from 'tgui-core/components';
import { useBackend } from 'tgui/backend';
import type { Data } from '..';
import { instaflogInsetField, instaflogPanel } from '../instaflogStyles';
import { GlossButton, InstaFlogAppHeader } from './InstaFlogComponents';
import { InstaFlogScreen } from './InstaFlogScreen';

type AuthMode = 'login' | 'register';

type AuthProps = {
  onBack: () => void;
  onClickSound: () => void;
};

const FieldLabel = (props: { children: ReactNode }) => (
  <div className="InstaFlog__FieldLabel">{props.children}</div>
);

const FieldError = (props: { children: ReactNode }) => (
  <div className="InstaFlog__FieldError">{props.children}</div>
);

const authTabStyle = (active: boolean): CSSProperties => ({
  flex: 1,
  textAlign: 'center',
  padding: '5px 6px',
  fontSize: '10px',
  fontWeight: active ? 700 : 500,
  color: active ? '#4a2f0e' : '#7a5528',
  background: active
    ? 'linear-gradient(180deg, #f7e3b2 0%, #e8c878 100%)'
    : 'rgba(255,255,255,0.15)',
  border: `1px solid ${active ? '#b8894f' : 'transparent'}`,
  borderRadius: '6px',
  cursor: 'pointer',
  lineHeight: 1.3,
});

export const InstaFlogAuth = (props: AuthProps) => {
  const { onBack, onClickSound } = props;
  const { act, data } = useBackend<Data>();
  const canRegister = !!data.show_instaflog_registration;

  const [mode, setMode] = useState<AuthMode>('login');
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [displayName, setDisplayName] = useState('');
  const [bio, setBio] = useState('');
  const [city, setCity] = useState('');
  const [profilePhotoUrl, setProfilePhotoUrl] = useState('');
  const [usernameError, setUsernameError] = useState(false);
  const [passwordError, setPasswordError] = useState(false);
  const [urlError, setUrlError] = useState(false);

  const normalizeUsername = (value: string) =>
    value
      .toLowerCase()
      .replace(/\s+/g, '_')
      .replace(/[^a-z0-9_]/g, '')
      .slice(0, 16);

  const compactField: CSSProperties = {
    ...instaflogInsetField,
    padding: '4px 6px',
    fontSize: '10px',
    lineHeight: 1.4,
    minHeight: '22px',
  };

  const handleLogin = () => {
    const normalizedUsername = normalizeUsername(username);
    if (!normalizedUsername) {
      setUsernameError(true);
      return;
    }
    if (!password) {
      setPasswordError(true);
      return;
    }
    setUsernameError(false);
    setPasswordError(false);
    onClickSound();
    act('instaflog_login', {
      username: normalizedUsername,
      password,
    });
  };

  const handleRegister = () => {
    const normalizedUsername = normalizeUsername(username);
    if (!normalizedUsername) {
      setUsernameError(true);
      return;
    }
    if (!password || password.length < 4) {
      setPasswordError(true);
      return;
    }
    if (password !== confirmPassword) {
      setPasswordError(true);
      return;
    }
    if (!displayName.trim()) {
      return;
    }
    const trimmedUrl = profilePhotoUrl.trim();
    if (trimmedUrl && !/^https?:\/\//i.test(trimmedUrl)) {
      setUrlError(true);
      return;
    }
    setUsernameError(false);
    setPasswordError(false);
    setUrlError(false);
    onClickSound();
    act('instaflog_register', {
      username: normalizedUsername,
      password,
      confirm_password: confirmPassword,
      display_name: displayName.trim(),
      bio,
      city,
      profile_photo_url: profilePhotoUrl,
    });
  };

  return (
    <InstaFlogScreen
      background="#e8d2a5"
      header={
        <InstaFlogAppHeader
          minimal
          title={mode === 'login' ? 'Entrar' : 'Cadastro'}
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
        <div className="InstaFlog__AuthTabs" style={{ marginBottom: '8px' }}>
          <button
            type="button"
            className="InstaFlog__AuthTab"
            style={authTabStyle(mode === 'login')}
            onClick={() => {
              onClickSound();
              setMode('login');
            }}
          >
            Entrar
          </button>
          <button
            type="button"
            className="InstaFlog__AuthTab"
            style={authTabStyle(mode === 'register')}
            onClick={() => {
              onClickSound();
              setMode('register');
            }}
          >
            Cadastrar
          </button>
        </div>

        <div className="InstaFlog__RegistrationForm">
          <div>
            <FieldLabel>Nome de usuário *</FieldLabel>
            <input
              className="InstaFlog__FormField"
              style={compactField}
              value={username}
              maxLength={16}
              placeholder="ex: maria_sp"
              onChange={(event) => {
                setUsernameError(false);
                setUsername(normalizeUsername(event.target.value));
              }}
            />
            {usernameError && (
              <FieldError>Nome inválido. Use letras, números ou _.</FieldError>
            )}
          </div>

          <div>
            <FieldLabel>Senha *</FieldLabel>
            <input
              className="InstaFlog__FormField"
              type="password"
              style={compactField}
              value={password}
              maxLength={32}
              placeholder="Mínimo 4 caracteres"
              onChange={(event) => {
                setPasswordError(false);
                setPassword(event.target.value);
              }}
            />
            {passwordError && mode === 'login' && (
              <FieldError>Senha obrigatória.</FieldError>
            )}
            {passwordError && mode === 'register' && (
              <FieldError>
                Senha inválida ou não coincide com a confirmação.
              </FieldError>
            )}
          </div>

          {mode === 'register' && !canRegister && (
            <FieldError>
              * Você não sabe o que você está fazendo...você não consegue se registrar.
            </FieldError>
          )}

          {mode === 'register' && (
            <>
              <div>
                <FieldLabel>Confirmar senha *</FieldLabel>
                <input
                  className="InstaFlog__FormField"
                  type="password"
                  style={compactField}
                  value={confirmPassword}
                  maxLength={32}
                  onChange={(event) => {
                    setPasswordError(false);
                    setConfirmPassword(event.target.value);
                  }}
                />
              </div>

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
            </>
          )}

          <Stack mt={0.5} justify="center">
            <GlossButton
              tone={mode === 'register' && !canRegister ? 'gray' : 'green'}
              onClick={
                mode === 'login'
                  ? handleLogin
                  : canRegister
                    ? handleRegister
                    : undefined
              }
            >
              {mode === 'login' ? 'Acessar conta' : 'Criar conta'}
            </GlossButton>
          </Stack>
        </div>
      </div>
    </InstaFlogScreen>
  );
};
