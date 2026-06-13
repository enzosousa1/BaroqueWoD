// THIS IS A DARKPACK UI FILE
import { useState } from 'react';

import {
  Box,
  Button,
  DmIcon,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

/** Displays user details if an ID is present and the user is on the station */
export const UserDetails = (props) => {
  const { data } = useBackend();
  const { user } = data;

  return (
    <NoticeBox m={0} color={user && 'blue'}>
      {(data.user &&
        (data.user.money > 0 || data.user.is_card === 1) &&
        ((data.user.is_card === 0 && (
          <Box>
            You seem to have $<b>{data.user.money}</b> in hand. Products over
            $1000 require card to purchase.
          </Box>
        )) ||
          (data.user.is_card === 1 && (
            <Box>
              I see you are paying with <b>card</b>. Products over $20 dollars
              require you to input your pin. What would you like to order?
            </Box>
          )))) || <Box color="light-gray">No cash, no card, no service!</Box>}
    </NoticeBox>
  );
};

export const RetailVendor = (props) => {
  const { act, data } = useBackend();
  const inventory = [...data.product_records];

  // NOCTURNE ADDTION START
  const [selectedCategory, setSelectedCategory] = useState(
    Object.keys(data.categories)[0],
  );

  const filteredCategories = Object.fromEntries(
    Object.entries(data.categories).filter(([categoryName]) => {
      return inventory.find((product) => {
        if ('category' in product) {
          return product.category === categoryName;
        } else {
          return false;
        }
      });
    }),
  );
  // NOCTURNE ADDITION END

  return (
    <Window width={431} height={635} resizable>
      <Window.Content scrollable>
        <Stack fill vertical>
          <Stack.Item>
            <UserDetails />
          </Stack.Item>
          <Section title="Products">
            <Table>
              {/* NOCTURNE REMOVAL START
              {inventory.map((product) => {
                return (
                  <Table.Row key={product.name}>
                    <Table.Cell>
                      <DmIcon
                        icon={product.icon}
                        icon_state={product.icon_state}
                        style={{
                          'vertical-align': 'middle',
                        }}
                      />{' '}
                      <b>{product.name}</b>
                    </Table.Cell>
                    <Table.Cell>
                      <Button
                        style={{
                          'min-width': '60px',
                          'text-align': 'center',
                        }}
                        disabled={
                          !data.user ||
                          (product.price > data.user.money &&
                            data.user.is_card === 0) ||
                          product.stock === 0
                        }
                        content={`${data.money_symbol}${product.price}`}
                        onClick={() =>
                          act('purchase', {
                            ref: product.ref,
                            payment_item: data.user.payment_item,
                          })
                        }
                      />
                    </Table.Cell>
                    <Table.Cell>
                      {product.stock > -1 && <b>Stock: {product.stock}</b>}
                    </Table.Cell>
                  </Table.Row>
                );
              })}
              NOCTURNE REMOVAL END */}

              {/* NOCTURNE ADDITION START */}
              {inventory
                .filter((product) => {
                  if ('category' in product) {
                    return product.category === selectedCategory;
                  } else {
                    return true;
                  }
                })
                .map((product) => {
                  return (
                    <Table.Row key={product.name}>
                      <Table.Cell
                        style={{
                          'width': '100%',
                        }}
                      >
                        <DmIcon
                          icon={product.icon}
                          icon_state={product.icon_state}
                          style={{
                            'vertical-align': 'middle',
                          }}
                        />{' '}
                        <b>{product.name}</b>
                      </Table.Cell>
                      <Table.Cell>
                        <Button
                          style={{
                            'min-width': '60px',
                            'text-align': 'center',
                          }}
                          disabled={
                            !data.user ||
                            (product.price > data.user.money &&
                              data.user.is_card === 0) ||
                            product.stock === 0
                          }
                          content={`${data.money_symbol}${product.price}`}
                          onClick={() =>
                            act('purchase', {
                              ref: product.ref,
                              payment_item: data.user.payment_item,
                            })
                          }
                        />
                      </Table.Cell>
                    </Table.Row>
                  );
                })
              }
              {/* NOCTURNE ADDITION END */}
            </Table>
          </Section>
          {/* NOCTURNE ADDITION START */}
          {Object.keys(filteredCategories).length > 1 && (
            <Stack.Item>
              <Section>
                {Object.entries(data.categories).map(([name, category]) => (
                  <Button
                    key={name}
                    selected={name === selectedCategory}
                    icon={category.icon}
                    onClick={() => setSelectedCategory(name)}
                  >
                    {name}
                  </Button>
                ))}
              </Section>
            </Stack.Item>
          )}
          {/* NOCTURNE ADDITION END */}
        </Stack>
      </Window.Content>
    </Window>
  );
};
