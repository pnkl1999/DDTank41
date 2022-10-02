using System;
using System.Collections.Generic;
using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Actions
{
    public class LivingRangeAttackingAction : BaseAction
    {
        private readonly Living living;

        private readonly List<Player> players;

        private readonly int fx;

        private readonly int tx;

        private string action;

        private readonly bool removeFrost;

        private readonly bool directDamage;

        private readonly int fy;

        private readonly int ty;
        private readonly float _damagePlus;

        public LivingRangeAttackingAction(Living living, int fx, int tx, string action, int delay, bool removeFrost,
            bool directDamage, List<Player> players, int fy, int ty, float damagePlus = 0f) : base(delay, 1000)
        {
            this.living = living;
            this.players = players;
            this.fx = fx;
            this.tx = tx;
            this.action = action;
            this.removeFrost = removeFrost;
            this.directDamage = directDamage;
            this.fy = fy;
            this.ty = ty;
            _damagePlus = damagePlus;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
            var gSPacketIn = new GSPacketIn(91, living.Id)
            {
                Parameter1 = living.Id
            };
            gSPacketIn.WriteByte(61);
            var livings = game.Map.FindPlayers(fx, tx, players, fy, ty);
            if (living is Player)
            {
                livings.Clear();
                livings.AddRange(game.Map.GetAllLivings());
                livings.AddRange(game.Map.GetAllPlayers());
            }

            var count = livings.Count;
            foreach (var currentLiving in livings)
            {
                if (living.IsFriendly(currentLiving))
                    count--;
            }

            gSPacketIn.WriteInt(count);
            living.SyncAtTime = false;
            try
            {
                foreach (var currentLiving in livings)
                {
                    currentLiving.SyncAtTime = false;
                    if (living.IsFriendly(currentLiving)) continue;
                    var dander = 0;
                    if (currentLiving.IsHide)
                    {
                        currentLiving.IsHide = false;
                        game.SendGameUpdateHideState(currentLiving);
                    }

                    if (removeFrost)
                        if (currentLiving.IsFrost)
                            currentLiving.IsFrost = false;

                    var damage = MakeDamage(currentLiving);
                    var critical = MakeCriticalDamage(currentLiving, damage);
                    var totalDamage = 0;
                    if (currentLiving is Player) currentLiving.OnTakedDamage(currentLiving, ref damage, ref critical);
                    if (currentLiving.TakeDamage(living, ref damage, ref critical, "范围攻击"))
                    {
                        totalDamage = damage + critical;
                        if (currentLiving is Player player) dander = player.Dander;
                    }

                    gSPacketIn.WriteInt(currentLiving.Id);
                    gSPacketIn.WriteInt(totalDamage);
                    gSPacketIn.WriteInt(currentLiving.Blood);
                    gSPacketIn.WriteInt(dander);
                    gSPacketIn.WriteInt(1);
                }

                game.SendToAll(gSPacketIn);
                Finish(tick);
            }
            finally
            {
                living.SyncAtTime = true;
                foreach (var living2 in livings) living2.SyncAtTime = true;
            }
        }

        private int MakeDamage(Living currentLiving)
        {
            var baseDamage = this.living.BaseDamage;
            var baseGuard = currentLiving.BaseGuard;
            var defence = currentLiving.Defence;
            var attack = this.living.Attack;
            if (currentLiving.AddArmor && (currentLiving as Player)?.DeputyWeapon != null)
            {
                var property7 = ((Player)currentLiving).DeputyWeapon.Template.Property7 +
                                (int)Math.Pow(1.1, ((Player)currentLiving).DeputyWeapon.StrengthenLevel);
                baseGuard += property7;
                defence += property7;
            }

            if (this.living.IgnoreArmor)
            {
                baseGuard = 0;
                defence = 0;
            }

            var currentDamagePlus = this.living.CurrentDamagePlus + _damagePlus;
            var currentShootMinus = this.living.CurrentShootMinus;
            var grade = 0.95 * (baseGuard - 3 * this.living.Grade) / (500 + baseGuard - 3 * this.living.Grade);
            double num = 0;
            num = defence - this.living.Lucky >= 0 ? 0.95 * (defence - this.living.Lucky) / (600 + defence - this.living.Lucky) : 0;
            var num1 = baseDamage * (1 + attack * 0.001) * (1 - (grade + num - grade * num)) * currentDamagePlus *
                       currentShootMinus;
            if (!directDamage)
            {
                var directDemageRect = currentLiving.GetDirectDemageRect();
                var num2 = Math.Sqrt((directDemageRect.X - this.living.X) * (directDemageRect.X - this.living.X) +
                                     (directDemageRect.Y - this.living.Y) * (directDemageRect.Y - this.living.Y));
                num1 = num1 * (1 - num2 / Math.Abs(tx - fx) / 4);
            }

            if (num1 < 0) return 1;
            return (int)num1;
        }

        private int MakeCriticalDamage(Living currentLiving, int damage)
        {
            var lucky = this.living.Lucky;
            var random = new Random();
            if (75000 * lucky / (lucky + 800) <= random.Next(100000)) return 0;
            var reduceCritFisrtGem = currentLiving.ReduceCritFisrtGem + currentLiving.ReduceCritSecondGem;
            return (int)((0.5 + lucky * 0.0003) * damage) * (100 - reduceCritFisrtGem) / 100;
        }
    }
}