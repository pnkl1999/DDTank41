using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic.Effects;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class SimpleKingLast : ABrain
    {
        public int attackingTurn = 1;

        public int orchinIndex = 1;

        public int currentCount = 0;

        public int Dander = 0;

        public List<SimpleNpc> orchins = new List<SimpleNpc>();

        #region NPC 说话内容
        private static string[] AllAttackChat = new string[]{
             "看我的绝技！",
          
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
            "来啊，<br/>让他们尝尝炸弹的厉害！"                          
        };

        private static string[] AngryChat = new string[]{
            "是你们逼我使出绝招的！"                          
        };

        private static string[] KillAttackChat = new string[]{
            "你来找死吗？"                          
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
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 390 && player.X < 1110)
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
                KillAttack(390, 1110);
                return;
            }

            if (result == true)
            {
                return;
            }

            if (attackingTurn == 1)
            {
                Body.Direction = Game.FindlivingbyDir(Body);
                HalfAttack();
            }
            else if (attackingTurn == 2)
            {
                Body.Direction = -Body.Direction;
                Summon();
            }
            else if (attackingTurn == 3)
            {
                Body.Direction = -Body.Direction;
                Seal();
            }
            else if (attackingTurn == 4)
            {
                Body.Direction = -Body.Direction;
                Angger();
            }
            else
            {
                Body.Direction = -Body.Direction;
                GoOnAngger();
                attackingTurn = 0;
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
            if (Body.Direction == 1)
            {
                Body.RangeAttacking(Body.X, Body.X + 1000, "cry", 3300, null);
            }
            else
            {
                Body.RangeAttacking(Body.X - 1000, Body.X, "cry", 3300, null);
            }
        }

        public void Summon()
        {
            int index = Game.Random.Next(0, CallChat.Length);
            Body.Say(CallChat[index], 1, 0);
            Body.PlayMovie("beatA", 100, 0);
            Body.CallFuction(new LivingCallBack(CreateChild), 2500);
        }

        public void Seal()
        {
            int index = Game.Random.Next(0, SealChat.Length);
            ((SimpleBoss)Body).Say(SealChat[index], 1, 0);
            Player m_player = Game.FindRandomPlayer();
            if (m_player == null)
                return;
            Body.PlayMovie("mantra", 2000, 2000);
            Body.Seal(m_player, 1, 3000);
        }

        public void Angger()
        {
            int index = Game.Random.Next(0, AngryChat.Length);
            Body.Say(AngryChat[index], 1, 0);
            Body.State = 1;
            Dander = Dander + 100;
            ((SimpleBoss)Body).SetDander(Dander);
            if (Body.Direction == -1)
            {
                ((SimpleBoss)Body).SetRelateDemagemRect(8, -252, 74, 50);
            }
            else
            {
                ((SimpleBoss)Body).SetRelateDemagemRect(-82, -252, 74, 50);
            }
        }

        public void GoOnAngger()
        {
            if (Body.State == 1)
            {
                Body.CurrentDamagePlus = 1000;
                Body.PlayMovie("beatC", 3500, 0);
                Body.RangeAttacking(Body.X - 1000, Body.X + 1000, "cry", 5600, null);
                Body.Die(5600);
            }
            else
            {
                ((SimpleBoss)Body).SetRelateDemagemRect(-41, -187, 83, 140);

                Body.PlayMovie("mantra", 0, 2000);
                List<Player> players = Game.GetAllLivingPlayers();

                foreach (Player player in players)
                {
                    player.AddEffect(new ContinueReduceBloodEffect(2,50, player), 0);
                }
            }
        }

        public void KillAttack(int fx, int mx)
        {
            Body.CurrentDamagePlus = 10;
            int index = Game.Random.Next(0, KillAttackChat.Length);
            ((SimpleBoss)Body).Say(KillAttackChat[index], 1, 500);
            Body.PlayMovie("beatB", 2500, 0);
            Body.RangeAttacking(fx, mx, "cry", 3300, null);
        }

        public void CreateChild()
        {
            ((SimpleBoss)Body).CreateChild(4, 520, 530, 400, 6, 1);
        }
    }
}
