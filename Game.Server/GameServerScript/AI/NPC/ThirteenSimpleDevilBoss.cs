using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic;
using Game.Logic.Phy.Object;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirteenSimpleDevilBoss : ABrain
    {
        private int m_attackTurn = 0;

        private SimpleBoss m_friendNpc;

        protected Player m_targer;

        protected Player m_targerBig1000;

        private SimpleNpc m_npc;

        private List<PhysicalObj> phyObjects = new List<PhysicalObj>();

        private PhysicalObj phyBig1000;

        private List<PhysicalObj> phyIronFire = new List<PhysicalObj>();

        private int m_friendBoss = 13007;

        private int m_npcId = 13010; // hop quai di



        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
            if (m_friendNpc == null)
            {
                SimpleBoss[] npcs = ((PVEGame)Game).FindLivingTurnBossWithID(m_friendBoss);
                if (npcs.Length > 0)
                    m_friendNpc = npcs[0];
            }
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();

            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;

            if (phyObjects != null && phyObjects.Count > 0)
            {
                foreach (PhysicalObj phy in phyObjects)
                {
                    Game.RemovePhysicalObj(phy, true);
                }
                phyObjects.Clear();
            }

        }

        public override void OnCreated()
        {
            base.OnCreated();
            Body.Properties1 = 0;
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();

            switch (m_attackTurn)
            {
                case 0:
                    CreateBig1000();
                    break;

                case 1:
                    DefaultAttack();
                    break;

                case 2:
                    CreateDamageBox();
                    break;

                case 3:
                    CreateDamageFire();
                    break;
                case 4:
                    CreateGlobalAttack();
                    m_attackTurn = -1;
                    break;
            }
            m_attackTurn++;
        }

        private void CreateGlobalAttack()
        {
            Body.ChangeDirection(-1, 500);
            Body.MoveTo(900, 400, "fly", 1000, 10, RunGlobalAttack);
        }

        private void RunGlobalAttack()
        {
            Body.CurrentDamagePlus = 2.5f;
            Body.PlayMovie("beatA", 1200, 0);
            Body.CallFuction(new LivingCallBack(CreateGlobalAttackEffect), 2500);
            Body.RangeAttacking(Body.X - 10000, Body.X + 10000, "cry", 4500, true);
            Body.PlayMovie("beatC", 4000, 2000);

            Body.CallFuction(FlyRandom, 5000);
        }

        private void CreateGlobalAttackEffect()
        {
            phyObjects.Add(((PVEGame)Game).CreateLayerTop(500, 300, "", "asset.game.4.heip", "", 1, 1));
        }

        private void CreateDamageFire()
        {
            Body.Say(Game.ListPlayersName() + ", ta muốn ăn thịt xông khói đây...", 0, 1000);

            Body.PlayMovie("beatD", 2000, 4000);

            Body.CallFuction(CreateFireEffect, 4000);
        }

        private void CreateFireEffect()
        {
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                phyIronFire.Add(((PVEGame)Game).Createlayer(p.X, p.Y - 50, "", "asset.game.ten.laotie", "born", 1, 1));
            }
        }

        private void CreateDamageBox()
        {
            m_targer = Game.FindRandomPlayer();

            Body.ChangeDirection(Game.FindRandomPlayer(), 1000);

            Body.Say("Bắt chúng nhốt lại cho ta.", 0, 2000);

            Body.PlayMovie("beatD", 3000, 0);

            Body.CallFuction(CreateNpcBoxToTarget, 4000);

            (Game as PVEGame).SendObjectFocus(m_targer, 1, 6000, 0);

            Body.CallFuction(new LivingCallBack(CreateEffectMovePlayer), 7000);
            Body.CallFuction(new LivingCallBack(BlockAndHidePlayer), 8000);

            Body.CallFuction(CallMoveAndCloseBox, 8000);
        }

        private void CallMoveAndCloseBox()
        {
            m_targer.BoltMove(m_npc.X, m_npc.Y, 100);

            ((PVEGame)Game).SendObjectFocus(m_npc, 1, 800, 0);

            m_npc.PlayMovie("AtoB", 1500, 2000);
        }

        private void CreateNpcBoxToTarget()
        {
            int randX = Game.Random.Next(200, 1700);
            LivingConfig config = ((PVEGame)Game).BaseConfig();
            config.CanTakeDamage = false;

            m_npc = ((SimpleBoss)Body).CreateChild(m_npcId, randX, 1000, false, config);
            m_npc.Properties1 = m_targer.Id;

            (Game as PVEGame).SendObjectFocus(m_npc, 1, 0, 0);
        }

        private void CreateEffectMovePlayer()
        {
            phyObjects.Add(((PVEGame)Game).Createlayer(m_targer.X, m_targer.Y, "", "asset.game.4.lanhuo", "", 1, 1));
        }

        private void BlockAndHidePlayer()
        {
            m_targer.SetVisible(false);
            m_targer.BlockTurn = true;
        }

        private void DefaultAttack()
        {
            m_targer = Game.FindRandomPlayer();
            Body.Say("Coi ta cắt chym tụi mi đây.", 0, 1000);
            Body.MoveTo(m_targer.X, m_targer.Y, "fly", 1500, 10, AttackTarget);
        }

        private void AttackTarget()
        {
            Body.BeatDirect(m_targer, "beatE", 0, 1, 1);
            Body.CallFuction(FlyRandom, 2000);
        }

        private void FlyRandom()
        {
            int x = Game.Random.Next(100, 1800);
            int y = Game.Random.Next(100, 850);
            Body.MoveTo(x, y, "fly", 1000, 10, CallAttackFriendlyBoss);
        }

        private void UpdateStatusDamage()
        {
            m_friendNpc.Properties1 = 1;
            m_friendNpc.Config.CancelGuard = true;

            (Game as PVEGame).SendLivingActionMapping(m_friendNpc, "stand", "standC");
            (Game as PVEGame).SendLivingActionMapping(m_friendNpc, "cry", "standC");
        }

        private void CallAttackFriendlyBoss()
        {
            if (phyBig1000 != null)
            {
                (Game as PVEGame).SendObjectFocus(phyBig1000, 1, 1000, 0);

                // check xem friendly boss co trong pham di nay khong
                if (m_friendNpc.X >= phyBig1000.X - 160 && m_friendNpc.X <= phyBig1000.X + 160)
                {
                    // trong pham vi tan cong
                    phyBig1000.PlayMovie("beatB", 2000, 0);

                    m_friendNpc.PlayMovie("ready", 3000, 0);
                    m_friendNpc.PlayMovie("standC", 3700, 2000);

                    Body.CallFuction(UpdateStatusDamage, 5700);
                }
                else
                {
                    Body.CurrentDamagePlus = 10f;
                    // khong trong pham vi => check va gay damage toan bo player trong pham vi
                    phyBig1000.PlayMovie("beatA", 2000, 3000);

                    // scan player on map
                    foreach (Player p in Game.GetAllLivingPlayers())
                    {
                        if (p.X >= phyBig1000.X - 160 && p.X <= phyBig1000.X + 160)
                        {
                            Body.BeatDirect(p, "", 3000, 1, 1);
                        }
                    }
                }

                Body.CallFuction(RemoveBig1000Object, 5000);
            }
            else if (phyIronFire.Count > 0)
            {
                List<Player> rangePlayers = Game.FindRangePlayers(m_friendNpc.X - 100, m_friendNpc.X + 100);
                if (rangePlayers.Count >= 4)
                {
                    // du 4 thanh vien xung quanh boss => di boss
                    (Game as PVEGame).SendObjectFocus(m_friendNpc, 1, 1000, 0);
                    Body.CallFuction(ClearAllFireDamageEffect, 2500);
                    Body.CallFuction(CreateFireIronFriendBoss, 3500);

                    foreach (PhysicalObj obj in phyIronFire)
                    {
                        obj.PlayMovie("beatA", 5000, 0);
                    }

                    m_friendNpc.PlayMovie("ready", 6500, 0);
                    m_friendNpc.PlayMovie("standC", 7200, 2000);

                    Body.CallFuction(UpdateStatusDamage, 9200);
                }
                else
                {
                    Body.CurrentDamagePlus = 5f;
                    // khong du 4 thanh vien => giet
                    foreach (PhysicalObj obj in phyIronFire)
                    {
                        obj.PlayMovie("beatA", 1000, 4000);
                        rangePlayers = Game.FindRangePlayers(obj.X - 25, obj.X + 25);
                        if (rangePlayers.Count > 0)
                        {
                            foreach (Player p in rangePlayers)
                            {
                                Body.BeatDirect(p, "", 2000, 1, 1);
                            }
                        }
                        Body.CallFuction(ClearAllFireDamageEffect, 4600);
                    }
                }
            }
        }

        private void CreateFireIronFriendBoss()
        {
            phyIronFire.Add((Game as PVEGame).Createlayer(m_friendNpc.X - 100, m_friendNpc.Y - 170, "", "asset.game.ten.laotie2", "", 1, 0));
            phyIronFire.Add((Game as PVEGame).Createlayer(m_friendNpc.X - 80, m_friendNpc.Y - 200, "", "asset.game.ten.laotie2", "", 1, 0));

            phyIronFire.Add((Game as PVEGame).Createlayer(m_friendNpc.X + 100, m_friendNpc.Y - 170, "", "asset.game.ten.laotie", "", 1, 0));
            phyIronFire.Add((Game as PVEGame).Createlayer(m_friendNpc.X + 80, m_friendNpc.Y - 200, "", "asset.game.ten.laotie", "", 1, 0));
        }

        private void ClearAllFireDamageEffect()
        {
            foreach (PhysicalObj phy in phyIronFire)
            {
                Game.RemovePhysicalObj(phy, true);
            }
            phyIronFire = new List<PhysicalObj>();
        }

        private void CreateBig1000()
        {
            m_targerBig1000 = Game.FindRandomPlayer();
            //(Game as PVEGame).SendPlayersPicture(m_targerBig1000, (int)BuffType.Targeting, true);

            Body.Say("Sao to và nặng value thế nhỉ?", 0, 1000);

            Body.PlayMovie("beatD", 2000, 0);

            (Game as PVEGame).SendFreeFocus(m_targerBig1000.X, m_targerBig1000.Y - 150, 1, 4000, 3000);

            Body.CallFuction(CreateBig1000Object, 5000);
        }

        private void CreateBig1000Object()
        {
            phyBig1000 = (Game as PVEGame).Createlayer(m_targerBig1000.X, m_targerBig1000.Y, "", "asset.game.ten.chengtuo", "", 1, 0);

            //m_targerBig1000.AddEffect(new AddTargetEffect(), 1000);
        }

        private void RemoveBig1000Object()
        {
            Game.RemovePhysicalObj(phyBig1000, true);
            phyBig1000 = null;
        }

        public override void OnDie()
        {
            base.OnDie();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
