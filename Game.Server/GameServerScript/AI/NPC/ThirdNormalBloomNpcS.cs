using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdNormalBloomNpcS : ABrain
    {

        private int m_recoverBlood = 500;
		
		private static string[] SayChat = new string[]{
             "Cẩn thận... chúng ta phải tiêu diệt tà thần",
               
             "Không được đầu hàng !",
             
             "Tôi sẽ tiếp cho các bạn sức mạnh！",
               
             "Chúng ta sẽ đẩy lùi bộ tộc tà thần！"       
        };
		
        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;
            if(Game.TurnIndex % 2 == 0)
            {
                int index = Game.Random.Next(0, SayChat.Length);
                Body.Say(SayChat[index], 1, 500);
            }
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            
            Body.PlayMovie("renew", 1000, 3000);
            Body.CallFuction(new LivingCallBack(RecoverBlood), 3000);
		}

        private void RecoverBlood()
        {
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > Body.X - 300 && player.X < Body.X + 300)
                {
                    player.AddBlood(m_recoverBlood);
                }
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
