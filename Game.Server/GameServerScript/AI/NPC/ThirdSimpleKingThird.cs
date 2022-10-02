using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic.Effects;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdSimpleKingThird : ABrain
    {
        private int attackingTurn = 1;

        private int orchinIndex = 1;

        private int currentCount = 0;

        private int Dander = 0;

        private int npcID = 3003;//CHIENSI
		
		private int npcID2 = 3112;//NO
		
		private int npcID1 = 3013;//MAU

        public List<SimpleNpc> orchins = new List<SimpleNpc>();

        #region NPC 说话内容
        private static string[] AllAttackChat = new string[]{
             "Tiếng gầm của mảnh hổ !!...",
          
             "这招酷吧，<br/>想学不？",
          
             "消失吧！！！<br/>卑微的灰尘！",

             "你们会为此付出代价的！ "
        };

        private static string[] ShootChat = new string[]{
             "你是在给我挠痒痒吗？",
               
             "我可不会像刚才那个废物一样被你打败！",
             
             "哎哟，你打的我好疼啊，<br/>哈哈哈哈！",
               
             "啧啧啧，就这样的攻击力！",
               
             "看到我是你们的荣幸！"          
        };

        private static string[] CallChat = new string[]{
            "Vũ điệu<br/>săn bắn...."                          
        };

        private static string[] AngryChat = new string[]{
            "是你们逼我使出绝招的！"                          
        };

        private static string[] KillAttackChat = new string[]{
            "Muốn xem lợi hại của cổ họng của ta!"                          
        };

        private static string[] SealChat = new string[]{
            "异次元放逐！"                          
        };

        private static string[] KillPlayerChat = new string[]{
            "灭亡是你唯一的归宿！",                  
 
            "太不堪一击了！"
        };
        #endregion


        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            bool result = false;
            int maxdis = 0;
			Body.Direction = Game.FindlivingbyDir(Body);
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 592 && player.X < 872)
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
                KillAttack(592, 872);
                return;
            }

            if (result == true)
            {
                return;
            }

            if (attackingTurn == 1)
            {
                HalfAttack();
            }
            else if (attackingTurn == 2)
            {
                PersonalAttack();
            }
            else if (attackingTurn == 3)
            {
                Summon();
            }
            else if (attackingTurn == 4)
            {
                PersonalAttackDame();
            }
            else
            {
                SummonNpc();
                attackingTurn = 1;
            }
            attackingTurn++;
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
			Game.RemoveLiving(npcID);
        }

        public void HalfAttack()
        {
            Body.CurrentDamagePlus = 0.5f;
            int index = Game.Random.Next(0, SealChat.Length);
            Body.Say(AllAttackChat[index], 1, 500);
            Body.PlayMovie("beatC", 2500, 0);
			Body.RangeAttacking(Body.X - 2000, Body.Y + 2000, "cry", 3000, null);
            
        }
		
		private void PersonalAttackDame()
        {
            Player target = Game.FindRandomPlayer();
            if (target == null)
                return;
            if (target.X > Body.Y)
            {
                Body.ChangeDirection(1, 800);
            }
            else
            {
                Body.ChangeDirection(-1, 800);
            }

            if (target != null)
            {

                int mtX = Game.Random.Next(target.X - 0, target.X + 0);

                if (Body.ShootPoint(target.X, target.Y, 55, 1000, 10000, 1, 1.5f, 2550))
                {
                    Body.PlayMovie("beatB", 1700, 0);
                }
            }
        }
		
		private void PersonalAttack()
        {
            int dis = Game.Random.Next(700, 800);
            Body.MoveTo(dis, Body.Y, "walk", 1000, "", 3, new LivingCallBack(NextAttack));
        }
		
		private void NextAttack()
        {
            Player target = Game.FindRandomPlayer();
            if (target == null)
                return;
            if (target.X > Body.Y)
            {
                Body.ChangeDirection(1, 800);
            }
            else
            {
                Body.ChangeDirection(-1, 800);
            }

            if (target != null)
            {

                int mtX = Game.Random.Next(target.X - 0, target.X + 0);

                if (Body.ShootPoint(target.X, target.Y, 54, 1000, 10000, 1, 1.5f, 2550))
                {
                    Body.PlayMovie("beatA", 1700, 0);
                }
            }
        }

        public void Summon()
        {
            int index = Game.Random.Next(0, CallChat.Length);
            Body.Say(CallChat[index], 1, 0);
            Body.PlayMovie("callA", 100, 0);
            Body.CallFuction(new LivingCallBack(CreateChild2), 2500);
        }
		
		public void SummonNpc()
        {
            int index = Game.Random.Next(0, CallChat.Length);
            Body.Say(CallChat[index], 1, 0);
            Body.PlayMovie("callB", 100, 0);
            Body.CallFuction(new LivingCallBack(CreateChild), 2500);
        }

        public void KillAttack(int fx, int mx)
        {
            Body.CurrentDamagePlus = 10;
            int index = Game.Random.Next(0, KillAttackChat.Length);
            ((SimpleBoss)Body).Say(KillAttackChat[index], 1, 500);
            Body.PlayMovie("beatC", 2500, 0);
            Body.RangeAttacking(fx, mx, "cry", 3300, null);
        }

        public void CreateChild()
        {
            ((SimpleBoss)Body).CreateChild(npcID, 520, 395, 50, 6, -1);
        }
		
		public void CreateChild2()
        {
            int dis = Game.Random.Next(100, 400);
			int dis2 = Game.Random.Next(150, 300);
            ((SimpleBoss)Body).CreateChild(npcID2, dis, 395, dis2, 6, -1);
        }
    }
}
