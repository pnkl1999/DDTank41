using Bussiness;
using Game.Base.Packets;
using Game.Logic.Phy.Object;
using System;

namespace Game.Logic.Actions
{
    public class LivingBeatDirectAction : BaseAction
    {
        private Living living_0;

        private Living living_1;

        private string string_0;

        private int int_0;

        private int int_1;

        public LivingBeatDirectAction(Living living, Living target, string action, int delay, int livingCount, int attackEffect)
			: base(delay)
        {
			living_0 = living;
			living_1 = target;
			string_0 = action;
			int_0 = livingCount;
			int_1 = attackEffect;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			living_1.SyncAtTime = false;
			try
			{
				GSPacketIn gSPacketIn = new GSPacketIn(91, living_0.Id);
				gSPacketIn.Parameter1 = living_0.Id;
				gSPacketIn.WriteByte(58);
				gSPacketIn.WriteString((!string.IsNullOrEmpty(string_0)) ? string_0 : "");
				gSPacketIn.WriteInt(int_0);
				for (int i = 1; i <= int_0; i++)
				{
					int damageAmount = living_0.MakeDamage(living_1);
					int criticalAmount = MakeCriticalDamage(damageAmount);
					int val = 0;
					if (living_1 is Player)
					{
						val = (living_1 as Player).Dander;
					}
					if (living_1.IsFrost)
					{
						living_1.IsFrost = false;
						game.method_30(living_1);
					}
					if (!living_1.TakeDamage(living_0, ref damageAmount, ref criticalAmount, "小怪伤血"))
					{
						Console.WriteLine("//error beat direct damage");
					}
					gSPacketIn.WriteInt(living_1.Id);
					gSPacketIn.WriteInt(damageAmount + criticalAmount);
					gSPacketIn.WriteInt(living_1.Blood);
					gSPacketIn.WriteInt(val);
					gSPacketIn.WriteInt(int_1);
				}
				game.SendToAll(gSPacketIn);
				Finish(tick);
			}
			finally
			{
				living_1.SyncAtTime = true;
			}
        }

        protected int MakeCriticalDamage(int baseDamage)
        {
			double lucky = living_0.Lucky;
			if (lucky * 45.0 / (800.0 + lucky) > (double)ThreadSafeRandom.NextStatic(100))
			{
				int num = living_1.ReduceCritFisrtGem + living_1.ReduceCritSecondGem;
				int num2 = (int)((0.5 + lucky * 0.00015) * (double)baseDamage);
				num2 = num2 * (100 - num) / 100;
				if (living_0.FightBuffers.ConsortionAddCritical > 0)
				{
					num2 += living_0.FightBuffers.ConsortionAddCritical;
				}
				return num2;
			}
			return 0;
        }
    }
}
