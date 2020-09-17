require 'rails_helper'

RSpec.describe Exercise9Controller do
  describe '#index' do
    let(:not_find_room) { 'Không tìm thấy phòng' }
    let(:finded_room) { 'Tìm thấy phòng' }
    let(:go_into_the_room) { 'Vào phòng' }
    let(:defeat_bigboss) { 'Đánh bại Big Boss' }

    shared_examples 'not find room' do
      let(:params) do
        {
          magic_wand: '0',
          companion_mage: '0',
          dark_key: dark_key,
          light_sword: light_sword
        }
      end

      it { expect(assigns(:result)).to eq not_find_room }
    end

    shared_examples 'find room with magic_wand' do
      let(:params) do
        {
          magic_wand: '1',
          companion_mage: companion_mage,
          dark_key: dark_key,
          light_sword: light_sword
        }
      end

      it { expect(assigns(:result)).to eq finded_room }
    end

    shared_examples 'find room with companion_mage' do
      let(:params) do
        {
          magic_wand: magic_wand,
          companion_mage: '1',
          dark_key: dark_key,
          light_sword: light_sword
        }
      end

      it { expect(assigns(:result)).to eq finded_room }
    end

    shared_examples 'go into the room' do
      let(:params) do
        {
          magic_wand: magic_wand,
          companion_mage: companion_mage,
          dark_key: '1',
          light_sword: light_sword
        }
      end

      it { expect(assigns(:result)).to eq go_into_the_room }
    end

    shared_examples 'defeat bigboss' do
      let(:params) do
        {
          magic_wand: magic_wand,
          companion_mage: companion_mage,
          dark_key: dark_key,
          light_sword: '1'
        }
      end

      it { expect(assigns(:result)).to eq defeat_bigboss }
    end

    before { get :index, params: params }

    context 'when not find room' do
      context 'and have not magic_wand, companion_mage' do
        context 'and have dark_key, light_sword' do
          let(:dark_key) { '1' }
          let(:light_sword) { '1' }
          include_examples 'not find room'
        end

        context 'and have not dark_key, light_sword' do
          let(:dark_key) { '0' }
          let(:light_sword) { '0' }
          include_examples 'not find room'
        end

        context 'and have dark_key but have not light_sword' do
          let(:dark_key) { '1' }
          let(:light_sword) { '0' }
          include_examples 'not find room'
        end

        context 'and have light_sword but have not dark_key' do
          let(:dark_key) { '0' }
          let(:light_sword) { '1' }
          include_examples 'not find room'
        end
      end
    end

    context 'when find room' do
      context 'and have magic_wand' do
        context 'and have companion_mage, light_sword but have not dark_key' do
          let(:companion_mage) { '1' }
          let(:dark_key) { '0' }
          let(:light_sword) { '1' }
          include_examples 'find room with magic_wand'
        end

        context 'and have companion_mage but have not dark_key, light_sword' do
          let(:companion_mage) { '1' }
          let(:dark_key) { '0' }
          let(:light_sword) { '0' }
          include_examples 'find room with magic_wand'
        end

        context 'and have light_sword but have not companion_mage, dark_key' do
          let(:companion_mage) { '0' }
          let(:dark_key) { '0' }
          let(:light_sword) { '1' }
          include_examples 'find room with magic_wand'
        end

        context 'and have not companion_mage, dark_key, light_sword' do
          let(:companion_mage) { '0' }
          let(:dark_key) { '0' }
          let(:light_sword) { '0' }
          include_examples 'find room with magic_wand'
        end
      end

      context 'and have companion_mage' do
        context 'and have not magic_wand, dark_key, light_sword' do
          let(:magic_wand) { '0' }
          let(:dark_key) { '0' }
          let(:light_sword) { '0' }
          include_examples 'find room with companion_mage'
        end

        context 'and have light_sword but have not magic_wand, dark_key' do
          let(:magic_wand) { '0' }
          let(:dark_key) { '0' }
          let(:light_sword) { '1' }
          include_examples 'find room with companion_mage'
        end
      end
    end

    context 'when go into the room' do
      context 'and have dark_key' do
        context 'and have magic_wand, companion_mage but have not light_sword' do
          let(:magic_wand) { '1' }
          let(:companion_mage) { '1' }
          let(:light_sword) { '0' }
          include_examples 'go into the room'
        end

        context 'and have magic_wand but have not companion_mage, light_sword' do
          let(:magic_wand) { '1' }
          let(:companion_mage) { '0' }
          let(:light_sword) { '0' }
          include_examples 'go into the room'
        end

        context 'and have companion_mage but have not magic_wand, light_sword' do
          let(:magic_wand) { '0' }
          let(:companion_mage) { '1' }
          let(:light_sword) { '0' }
          include_examples 'go into the room'
        end
      end
    end

    context 'when defeat bigboss' do
      context 'and light_sword' do
        context 'and have magic_wand, companion_mage, dark_key' do
          let(:magic_wand) { '1' }
          let(:companion_mage) { '1' }
          let(:dark_key) { '1' }
          include_examples 'defeat bigboss'
        end

        context 'and have magic_wand, dark_key but have not companion_mage' do
          let(:magic_wand) { '1' }
          let(:companion_mage) { '0' }
          let(:dark_key) { '1' }
          include_examples 'defeat bigboss'
        end

        context 'and have companion_mage, dark_key but have not magic_wand' do
          let(:magic_wand) { '0' }
          let(:companion_mage) { '1' }
          let(:dark_key) { '1' }
          include_examples 'defeat bigboss'
        end
      end
    end
  end
end
