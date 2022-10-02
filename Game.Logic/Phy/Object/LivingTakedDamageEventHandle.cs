namespace Game.Logic.Phy.Object
{
    public delegate void LivingTakedDamageEventHandle(Living living, Living source, ref int damageAmount, ref int criticalAmount);
}
