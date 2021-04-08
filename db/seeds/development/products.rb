
#  id         :bigint           not null, primary key
#  code       :string           not null
#  explain    :text
#  is_set     :boolean          default(FALSE)
#  name       :string
#  price      :integer          not null

Product.create!(
  code: 'grip_m4_2__bk',
  explain: 'this is first item',
  is_set: false,
  name: 'm4 グリップ',
  price: 10,
)
Product.create!(
  code: 'grip_m4_2__de',
  explain: 'this is second item',
  is_set: false,
  name: 'm4 グリップ DE',
  price: 10,
)
Product.create!(
  code: 'grip_ergo__de',
  explain: 'this is third item',
  is_set: false,
  name: 'ergo グリップ DE',
  price: 20,
)