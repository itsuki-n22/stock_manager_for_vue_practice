# == Schema Information
#
# Table name: orders
#
#  id              :bigint           not null, primary key
#  address         :string
#  customer_name   :string
#  delivery_charge :integer
#  order_number    :string           not null
#  phone_country   :integer
#  phone_number    :string
#  platform        :integer          default("不明"), not null
#  postal_code     :string
#  prefecture      :integer          default(0), not null
#  status          :integer          default("注文直後"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_orders_on_order_number  (order_number)
#  index_orders_on_status        (status)
#
class Order < ApplicationRecord
  enum status: ["注文直後","入金待ち","発送待ち", "配送済み", "キャンセル"]
  enum platform: ["不明", "ヤフオク1","ヤフオク2" ,"楽天", "Amazon", "Wowma", "Base", "Qoo10"]
  enum prefecture: [
          '北海道',
          '青森県',
          '岩手県',
          '宮城県',
          '秋田県',
          '山形県',
          '福島県',
          '茨城県',
          '栃木県',
          '群馬県',
          '埼玉県',
          '千葉県',
          '東京都',
          '神奈川県',
          '新潟県',
          '富山県',
          '石川県',
          '福井県',
          '山梨県',
          '長野県',
          '岐阜県',
          '静岡県',
          '愛知県',
          '三重県',
          '滋賀県',
          '京都府',
          '大阪府',
          '兵庫県',
          '奈良県',
          '和歌山県',
          '鳥取県',
          '島根県',
          '岡山県',
          '広島県',
          '山口県',
          '徳島県',
          '香川県',
          '愛媛県',
          '高知県',
          '福岡県',
          '佐賀県',
          '長崎県',
          '熊本県',
          '大分県',
          '宮崎県',
          '鹿児島県',
          '沖縄県'
        ]
end
