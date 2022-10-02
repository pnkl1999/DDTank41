using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdSimpleKingSecond : ABrain
    {
        private int m_attackTurn = 0;
		
		private int npcID = 3006;
		
		private int npcID2 = 3010;
		
		private PhysicalObj m_kingMoive;

        #region NPC 说话内容
        private static string[] AllAttackChat = new string[] { 
            "Trận động đất, bản thân mình! ! <br/> bạn vui lòng Ay giúp đỡ",
       
            "Hạ vũ khí xuống!",
       
            "Xem nếu bạn có thể đủ khả năng, một số ít!！"
        };
		
		private static string[] CallChat = new string[]{
            "Vệ binh! <br/> bảo vệ! ! ",
                  
            "Boo đệm! ! <br/> cung cấp cho tôi một số trợ giúp!"
        };

        private static string[] ShootChat = new string[]{
             "Nếm thử cái này!",
                               
             "Gửi cho bạn một quả bóng - bạn phải chọn Vâng",

             "Nhóm của bạn của những người dân thường ngu dốt và thấp"
        };

        private static string[] ShootedChat = new string[]{
           "Ah ~ ~ Tại sao bạn tấn công? <br/> tôi đang làm gì?",
                   
            "Oh ~ ~ nó thực sự đau khổ! Tại sao tôi phải chiến đấu? <br/> tôi phải chiến đấu ..."

        };

        private static string[] AddBooldChat = new string[]{
            "Xoắn ah xoay ~ <br/>xoắn ah xoay ~ ~ ~",
               
            "~ Hallelujah <br/>Luyaluya ~ ~ ~",
                
            "Yeah Yeah Yeah, <br/> để thoải mái!"
         
        };

        private static string[] KillAttackChat = new string[]{
            "Con rồng trong thế giới! !"
        };

        #endregion

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            Body.Direction = Game.FindlivingbyDir(Body);
            bool result = false;
            int maxdis = 0;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 0 && player.X < 300)
                {
                    int dis = (int)Body.Distance(player.X, player.Y);
                    if (dis > maxdis)
                    {
                        maxdis = dis;
                    }
                    result = true;
                }
            }

            if (result)
            {
                KillAttack(0, 300);
                return;
            }

            if (m_attackTurn == 0)
            {
                Jump2();
                m_attackTurn++;
            }
			else if (m_attackTurn == 1)
            {
                Star();
                m_attackTurn++;
            }
			else if (m_attackTurn == 2)
            {
                Jump();
                m_attackTurn++;
            }
			else if (m_attackTurn == 3)
            {
                Summon();
                m_attackTurn++;
            }
            else
            {
                Healing();
                m_attackTurn = 0;
            }
        }

        private void KillAttack(int fx, int tx)
        {
            Body.CurrentDamagePlus = 10;
            int index = Game.Random.Next(0, KillAttackChat.Length);
            Body.Say(KillAttackChat[index], 1, 1000);
            Body.PlayMovie("beat", 3000, 0);
            Body.RangeAttacking(fx, tx, "cry", 4000, null);
        }
		
		private void Star()
        {
		    m_kingMoive = ((PVEGame)Game).Createlayer(Body.X, Body.Y - 10, "moive", "asset.game.4.buff", "out", 1, 1);
			Body.CallFuction(new LivingCallBack(Remove), 1000);
		}	
		
		public void Remove()
        {
		    if (m_kingMoive != null)
                {
                    Game.RemovePhysicalObj(m_kingMoive, true);
                    m_kingMoive = null;
                }
		}		

        private void Jump()
        {
			Body.JumpTo(Body.X, Body.Y - 130, "", 1000, 1, 12, new LivingCallBack(NextAttack));   
        }
		
		private void Jump2()
        {
			Body.PlayMovie("walk", 100, 1000);
			Body.FallFromTo(Body.X, Body.Y + 130, "", 1000, 0, 25, new LivingCallBack(NextAttack)); 
        }

        public void Healing()
        {
            Body.SyncAtTime = true;
            Body.AddBlood(5000);
			Body.PlayMovie("castA", 100, 0);
            Body.Say("Định đánh bại bọn ta à, không dể đâu!", 0, 0);
        }
		
		private void Summon()
        {
            int index = Game.Random.Next(0, CallChat.Length);
            Body.Say(CallChat[index], 0, 3300);
            Body.PlayMovie("call", 3500, 0);
            Body.CallFuction(new LivingCallBack(CreateChild), 4000);

        }
		
		public void CreateChild()
        {
            ((SimpleBoss)Body).CreateChild(npcID2, 827, 628, 430, 1, -1);
        }


        private void NextAttack()
        {
            Player target = Game.FindRandomPlayer();

            Body.CurrentDamagePlus = 0.8f;

            int index = Game.Random.Next(0, ShootChat.Length);
            Body.Say(ShootChat[index], 0, 0);

            if (target != null)
            {
                int mtX = Game.Random.Next(target.X - 20, target.X + 20);

                if (Body.ShootPoint(mtX, target.Y, 54, 1000, 10000, 1, 1, 2300))
                {
                    Body.PlayMovie("beatA", 1500, 0);
                }

            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
