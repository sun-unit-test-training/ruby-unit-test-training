class Exercise9Controller < ApplicationController
  def index
    @result = HanoiQuest.find_by(key_result: key_result)&.result
  end

  private

  def key_result
    params.slice(:magic_wand, :companion_mage, :dark_key, :light_sword)
          .to_unsafe_h.values.map(&:to_i).join('')
  end
end
