using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic.Effects;
using System.Drawing;
using Game.Logic.Phy.Object;
using Game.Logic.Phy.Maths;
using SqlDataProvider.Data;
using Bussiness;


namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdSimpleKingFour : ABrain
    {
        private int attackingTurn = 1;

        private int orchinIndex = 1;

        private int currentCount = 0;

        private int Dander = 0;
		
		private int npcID = 3003;
		
		private int IsEixt = 0;
		
		private PhysicalObj m_kingMoive;

        public List<SimpleNpc> orchins = new List<SimpleNpc>();

        #region NPC 说话内容
        private static string[] AllAttackChat = new string[]{
             "看我的绝技！",
          
             "这招酷吧，<br/>想学不？",
          
             "消失吧！！！<br/>卑微的灰尘！",

             "你们会为此付出代价的！ "
        };

        private static string[] ShootChat = new string[]{
             "Lửa địa ngục...",
               
             "我可不会像刚才那个废物一样被你打败！",
             
             "哎哟，你打的我好疼啊，<br/>哈哈哈哈！",
               
             "啧啧啧，就这样的攻击力！",
               
             "看到我是你们的荣幸！"          
        };

        private static string[] CallChat = new string[]{
            "来啊，<br/>让他们尝尝炸弹的厉害！"                          
        };

        private static string[] AngryChat = new string[]{
            "是你们逼我使出绝招的！"                          
        };

        private static string[] KillAttackChat = new string[]{
            "你来找死吗？"                          
        };

        private static string[] SealChat = new string[]{
            "Chạy đường nào đây?"                        
        };

        private static string[] KillPlayerChat = new string[]{
            "Lửa bất diệt cháy bừng lên đi!"                 
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
                if (player.IsLiving && player.X > 572 && player.X < 872)
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
                KillAttack(572, 872);
                return;
            }

            if (result == true)
            {
                return;
            }

            if (attackingTurn == 1)
            {
				Summon();
            }
            else if (attackingTurn == 2)
            {
                PersonalAttackDame();
            }
            else if (attackingTurn == 3)
            {
                HalfAttack();
            }
			else if (attackingTurn == 4)
            {
                MovePlayer();
            }
			else if (attackingTurn == 5)
            {
                PersonalNpc();
            }
            else
            {
                HalfAttack();
                attackingTurn = 1;
            }
            attackingTurn++;
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }	

        public void HalfAttack()
        {
            Body.CurrentDamagePlus = 0.5f;
            int index = Game.Random.Next(0, SealChat.Length);
            Body.Say(AllAttackChat[index], 1, 500);
            Body.PlayMovie("beatB", 2500, 0);
            Body.RangeAttacking(Body.X - 2000, Body.Y + 2000, "cry", 3000, null);
        }
		
		private void PersonalAttackDame()
        {
            Player target = Game.FindRandomPlayer();
            if (target == null)
                return;

            int index = Game.Random.Next(0, ShootChat.Length);
            ((SimpleBoss)Body).Say(ShootChat[index], 1, 500);

            if (Body.X > target.X)
            {

                if (target.X > Body.Y)
                {
                Body.ChangeDirection(1, 50);
                }
                else
                {
                Body.ChangeDirection(-1, 50);
                }
				int mtX = Game.Random.Next(target.X - 10, target.X + 10);

                if (Body.ShootPoint(target.X, target.Y, 53, 1000, 10000, 3, 2.3f, 2600))
                {
                    Body.PlayMovie("aim", 1000, 0);
					Body.PlayMovie("beatA", 1500, 0);	
                }
				
				if (Body.ShootPoint(target.X, target.Y, 53, 1000, 10000, 3, 2.3f, 4600))
                {
                    Body.PlayMovie("aim", 3000, 0);
					Body.PlayMovie("beatA", 4500, 0);	
                }
				
				if (Body.ShootPoint(target.X, target.Y, 53, 1000, 10000, 3, 2.3f, 6600))
                {
                    Body.PlayMovie("aim", 5000, 0);
					Body.PlayMovie("beatA", 6500, 0);	
                }
            }
			
			else
            {

                if (target.X > Body.Y)
                {
                Body.ChangeDirection(1, 50);
                }
                else
                {
                Body.ChangeDirection(-1, 50);
                }
				int mtX = Game.Random.Next(target.X - 10, target.X + 10);

                if (Body.ShootPoint(target.X, target.Y, 53, 1000, 10000, 3, 1f, 2600))
                {
                    Body.PlayMovie("aim", 1000, 0);
					Body.PlayMovie("beatA", 1500, 0);	
                }
				
				if (Body.ShootPoint(target.X, target.Y, 53, 1000, 10000, 3, 1f, 4600))
                {
                    Body.PlayMovie("aim", 3000, 0);
					Body.PlayMovie("beatA", 4500, 0);	
                }
				
				if (Body.ShootPoint(target.X, target.Y, 53, 1000, 10000, 3, 1f, 6600))
                {
                    Body.PlayMovie("aim", 5000, 0);
					Body.PlayMovie("beatA", 6500, 0);	
                }
            }
        }
		
		private void PersonalNpc()
        {	
			int index = Game.Random.Next(0, CallChat.Length);
            ((SimpleBoss)Body).Say(CallChat[index], 1, 500);
			if (IsEixt == 1)
			{
			    {
                    Body.ChangeDirection(1, 50);
					
				    if (Body.ShootPoint(1000, 560, 53, 1000, 10000, 1, 2.0f, 2550))
                    {
                        Body.PlayMovie("aim", 1700, 0);
                    }
				    Body.PlayMovie("beatA", 2000, 0);
					IsEixt = 0;
				}
			}
            else
            {
                Body.ChangeDirection(-1, 50);
				
				if (Body.ShootPoint(478, 550, 53, 1000, 10000, 1, 2.0f, 2550))
                {
                    Body.PlayMovie("aim", 1700, 0);
                }
				Body.PlayMovie("beatA", 2000, 0);	
				IsEixt = 1;
            }			
        }
		
        public void Summon()
        {
			if (Body.State == 1)
            {
                Body.PlayMovie("beatC", 2500, 0);
				
            }
            else
            {

                Body.PlayMovie("beatC", 0, 2000);
                List<Player> players = Game.GetAllLivingPlayers();
				Player target = Game.FindRandomPlayer();
                if (target == null)
                    return;
                int index = Game.Random.Next(0, KillPlayerChat.Length);
                ((SimpleBoss)Body).Say(KillPlayerChat[index], 1, 500);

                foreach (Player player in players)
                {
                    player.AddEffect(new ContinueReduceBloodEffect(2, 500, player), 0);	
					
                }
                Body.CallFuction(new LivingCallBack(In), 1300);				
            }
        }
		
		public void In()
        {
            List<Player> players = Game.GetAllLivingPlayers();
		    Player target = Game.FindRandomPlayer();
            if (target == null)
                return;
            foreach (Player player in players)
                {
                   
				    m_kingMoive = ((PVEGame)Game).Createlayer(player.X, player.Y - 100, "moive", "asset.game.4.flame", "out", 1, 0);
                }
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
		
		public void MovePlayer()
        {
			if (Body.State == 1)
            {
                Body.PlayMovie("beatC", 2500, 0);
            }
            else
            {
                Body.PlayMovie("beatC", 0, 2000);
                List<Player> players = Game.GetAllLivingPlayers();
				Player target = Game.FindRandomPlayer();
				int index = Game.Random.Next(0, SealChat.Length);
                ((SimpleBoss)Body).Say(SealChat[index], 1, 500);

                foreach (Player player in players)
                {
                    int dis = Game.Random.Next(200, 1550);					
                    player.JumpToSpeed(dis, 400, "", 0, 0, 36, null);
					
                }			
            }
        }				
	
        public void KillAttack(int fx, int mx)
        {
            Body.CurrentDamagePlus = 10;
            int index = Game.Random.Next(0, KillAttackChat.Length);
            ((SimpleBoss)Body).Say(KillAttackChat[index], 1, 500);
            Body.PlayMovie("beatC", 2500, 0);
            Body.RangeAttacking(fx, mx, "cry", 3300, null);
        }

    }
}
