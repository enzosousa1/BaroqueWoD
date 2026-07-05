import type { ReactNode } from 'react';

type InstaFlogScreenProps = {
  background?: string;
  header: ReactNode;
  footer?: ReactNode;
  children: ReactNode;
};

export const InstaFlogScreen = (props: InstaFlogScreenProps) => {
  const { background = '#dbc79a', header, footer, children } = props;

  return (
    <div className="InstaFlog__App" style={{ background }}>
      <div className="InstaFlog__HeaderSlot">{header}</div>
      <div
        className={
          footer ? 'InstaFlog__Main' : 'InstaFlog__Main InstaFlog__Main--solo'
        }
      >
        {children}
      </div>
      {footer ? <div className="InstaFlog__Footer">{footer}</div> : null}
    </div>
  );
};