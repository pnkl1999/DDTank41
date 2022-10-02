using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic.Effects;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdTerrorKingThird : ABrain
    {
        private int attackingTurn = 1;

        private int npcID = 3303;//CHIENSI

        private int npcID2 = 3312;//NO

        private int npcID1 = 3313;//MAU

        private int maxRespawnNPC = 20;

        private int coldDownBuffBlood = 0;

        public List<SimpleNpc> orchins = new List<SimpleNpc>();

        #region NPC 说话内容
        private static string[] AllAttackChat = new string[]{
             "Tiếng gầm của mảnh hổ !!..."
        };

        private static string[] ShootChat = new string[]{
             "Nhìn có giống cái gì không?",
             "Ta ném!! Tá ném!!!!",
             "Giỏi thì né nữa đi.",
             "Bách phát bách trúng"
        };

        private static string[] CallChat = new string[]{
            "Vũ điệu<br/>săn bắn...."
        };

        private static string[] CallBuffChat = new string[]{
            "Sức mạnh bộ tộc<br/>Hãy giúp ta!!!",
            "Ta muốn có nhiều sức mạnh!!!!",
            "Tiếp sức cho ta tiêu diệt kẻ thù..."
        };

        private static string[] CallExplodeChat = new string[]{
            "Có đỡ được không?",
            "Bộ lạc hãy giúp ta",
            "Tiếp sức!!! Tiếp sức!!!!"
        };

        private static string[] AngryChat = new string[]{
            "Dám chọc giận ta à?",
            "Ta né, ta né!!!",
            "Đồ khốn nạn. Dám đánh ta!!"
        };

        private static string[] KillAttackChat = new string[]{
            "Muốn xem lợi hại của cổ họng của ta!"
        };


        #endregion


        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
            if (coldDownBuffBlood > 0)
                coldDownBuffBlood--;
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
                if (player.IsLiving && player.X > Body.X - 250 && player.X < Body.X + 250)
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
                KillAttack(Body.X - 250, Body.X + 250);
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
                // check can summon
                List<SimpleNpc> npcBuffBloods = (Body as SimpleBoss).FindChildLiving(npcID1);
                if (npcBuffBloods.Count <= 0)
                    Summon();
                else
                {
                    List<SimpleNpc> npcExplode = (Body as SimpleBoss).FindChildLiving(npcID2);
                    if (npcBuffBloods.Count <= 0)
                    {
                        SummonExplode();
                    }
                    else
                    {
                        PersonalAttack();
                    }
                }
            }
            else if (attackingTurn == 4)
            {
                PersonalAttackDame();
            }
            else if (attackingTurn == 5)
            {
                int rand = Game.Random.Next(0, 10);
                if (rand > 5)
                    SummonExplode();
                else
                    PersonalAttack();
            }
            else
            {
                if ((Body as SimpleBoss).FindChildLiving(npcID).Count <= 0)
                    SummonNpc();
                else
                    PersonalAttackDame();

                attackingTurn = 0;
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
            Body.CurrentDamagePlus = 1.5f;
            int index = Game.Random.Next(0, AllAttackChat.Length);
            Body.Say(AllAttackChat[index], 1, 500);
            Body.PlayMovie("beatC", 2500, 0);
            Body.RangeAttacking(Body.X - 10000, Body.Y + 10000, "cry", 3500, null);

        }

        private void PersonalAttackDame()
        {
            Player[] allPlayers = Game.GetAllPlayers();

            int delayTime = 200;

            int index = Game.Random.Next(0, ShootChat.Length);
            Body.Say(ShootChat[index], 1, delayTime);

            foreach (Player p in allPlayers)
            {
                if (p.IsLiving)
                {
                    delayTime += 200;
                    // change dic
                    Body.ChangeDirection(Body.FindDirection(p), delayTime);
                    // shoot it
                    delayTime += 2000;
                    if (Body.ShootPoint(p.X, p.Y, 55, 1000, 10000, 1, 1.5f, delayTime))
                    {
                        Body.PlayMovie("beatB", delayTime - 1000, 0);
                    }
                }
            }
        }

        private void PersonalAttack()
        {
            int dis = Game.Random.Next(700, 800);
            Body.MoveTo(dis, Body.Y, "walk", 1000, "", 4, new LivingCallBack(NextAttack));
        }

        private void NextAttack()
        {
            Player[] allPlayers = Game.GetAllPlayers();

            int delayTime = 200;

            int index = Game.Random.Next(0, ShootChat.Length);
            Body.Say(ShootChat[index], 1, delayTime);

            foreach (Player p in allPlayers)
            {
                if (p.IsLiving)
                {
                    delayTime += 200;
                    // change dic
                    Body.ChangeDirection(Body.FindDirection(p), delayTime);
                    // shoot it
                    delayTime += 2000;
                    if (Body.ShootPoint(p.X, p.Y, 54, 1000, 10000, 1, 1.5f, delayTime))
                    {
                        Body.PlayMovie("beatA", delayTime - 1000, 0);
                    }
                }
            }
        }

        public void Summon()
        {
            coldDownBuffBlood = 5;

            int index = Game.Random.Next(0, CallBuffChat.Length);
            Body.Say(CallBuffChat[index], 1, 0);
            Body.PlayMovie("callA", 100, 0);
            Body.CallFuction(new LivingCallBack(CreateBuffBlood), 2500);
        }

        public void SummonNpc()
        {
            int index = Game.Random.Next(0, CallChat.Length);
            Body.Say(CallChat[index], 1, 0);
            Body.PlayMovie("callB", 100, 0);
            Body.CallFuction(new LivingCallBack(CreateChild), 4500);
        }

        public void SummonExplode()
        {
            int index = Game.Random.Next(0, CallExplodeChat.Length);
            Body.Say(CallExplodeChat[index], 1, 0);
            Body.PlayMovie("callA", 100, 0);
            Body.CallFuction(new LivingCallBack(CreateExplode), 2500);
        }

        public void KillAttack(int fx, int mx)
        {
            Body.CurrentDamagePlus = 1000f;
            int index = Game.Random.Next(0, KillAttackChat.Length);
            ((SimpleBoss)Body).Say(KillAttackChat[index], 1, 500);
            Body.PlayMovie("beatC", 2500, 0);
            Body.RangeAttacking(fx, mx, "cry", 3300, null);
        }

        public void CreateChild()
        {
            int x = 1000;
            for (int i = 0; i < maxRespawnNPC; i++)
            {
                ((SimpleBoss)Body).CreateChild(npcID, x, 555, -1, maxRespawnNPC, -1);
                x -= 50;
            }
        }

        public void CreateBuffBlood()
        {
            ((SimpleBoss)Body).CreateBoss(npcID1, 568, 554, -1, 0);
            ((SimpleBoss)Body).CreateBoss(npcID1, 1093, 556, 1, 0);
        }

        public void CreateExplode()
        {
            Player p = Game.FindRandomPlayer();
            if (p != null)
            {
                ((SimpleBoss)Body).CreateBoss(npcID2, p.X, p.Y, p.Direction, 0);
            }
        }
    }
}
