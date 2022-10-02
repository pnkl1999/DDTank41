using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic;
using Game.Logic.Phy.Object;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class LongClickCannon : ABrain
    {
        private int m_attackTurn = 0;

        private int m_turn = 0;

        private PhysicalObj m_wallLeft = null;

        private PhysicalObj m_wallRight = null;

        private int IsEixt = 0;

        #region NPC 说话内容
        private static string[] AllAttackChat = new string[] { 
             "要地震喽！！<br/>各位请扶好哦",
       
             "把你武器震下来！",
       
             "看你们能还经得起几下！！"
        };

        private static string[] ShootChat = new string[]{
             "让你知道什么叫百发百中！",
                               
             "送你一个球~你可要接好啦",

             "你们这群无知的低等庶民"
        };

        private static string[] ShootedChat = new string[]{
           "哎呀~~你们为什么要攻击我？<br/>我在干什么？",
                   
            "噢~~好痛!我为什么要战斗？<br/>我必须战斗…"

        };

        private static string[] KillPlayerChat = new string[]{
             "马迪亚斯不要再控制我！",       

             "这就是挑战我的下场！",

             "不！！这不是我的意愿… " 
        };

        private static string[] AddBooldChat = new string[]{
            "扭啊扭~<br/>扭啊扭~~",
               
            "哈利路亚~<br/>路亚路亚~~",
                
            "呀呀呀，<br/>好舒服啊！"
         
        };

        private static string[] KillAttackChat = new string[]{
            "君临天下！！"
        };

        private static string[] FrostChat = new string[]{
            "来尝尝这个吧",
               
            "让你冷静一下",
               
            "你们激怒了我"
              
        };

        private static string[] WallChat = new string[]{
             "神啊，赐予我力量吧！",

             "绝望吧，看我的水晶防护墙！"
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
            bool result = false;
            int maxdis = 0;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 0 && player.X < 0)
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
                KillAttack(0, 0);
                return;
            }

            if (m_attackTurn == 0)
            {
                m_attackTurn++;
            }
            else if (m_attackTurn == 1)
            {
                ToA();
                m_attackTurn++;
            }
            else if (m_attackTurn == 2)
            {
                BeatA();
				m_attackTurn++;
            }
			else if (m_attackTurn == 3)
            {
                m_attackTurn++;
            }
            else if (m_attackTurn == 4)
            {
                m_attackTurn++;
            }
            else
            {
                m_attackTurn = 0;
            }
        }

        private void KillAttack(int fx, int tx)
        {
            int index = Game.Random.Next(0, KillAttackChat.Length);
            if (m_turn == 0)
            {
                Body.CurrentDamagePlus = 10;
                Body.Say(KillAttackChat[index], 1, 13000);
                Body.PlayMovie("beat1", 15000, 0);
                Body.RangeAttacking(fx, tx, "cry", 17000, null);
                m_turn++;
            }
            else
            {
                Body.CurrentDamagePlus = 10;
                Body.Say(KillAttackChat[index], 1, 0);
                Body.PlayMovie("beat1", 2000, 0);
                Body.RangeAttacking(fx, tx, "cry", 4000, null);
            }
        }

        private void ToA()
        {
            Body.PlayMovie("toA", 1000, 4000);
	
        }
		private void BeatA()
        {
            Body.PlayMovie("beatA", 1000, 0);
			Body.RangeAttacking(Body.X + 9000, Body.X - 9000, "cry", 3000, null);
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
