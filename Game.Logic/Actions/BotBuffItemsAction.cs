using Game.Logic.Phy.Object;
using SqlDataProvider.Data;

namespace Game.Logic.Actions
{
    public class BotBuffItemsAction : BaseAction
    {
        private Player m_player;

        private ItemTemplateInfo m_buff;

        public BotBuffItemsAction(Player player, ItemTemplateInfo buff, int delay)
			: base(delay, 1000)
        {
			m_player = player;
			m_buff = buff;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			if (m_buff != null)
			{
				m_player.UseItem(m_buff);
			}
			Finish(tick);
        }
    }
}
