package ddt.data
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.view.tips.BuffTipInfo;
   
   public class FightContainerBuff extends FightBuffInfo implements Disposeable
   {
       
      
      private var _buffs:Vector.<FightBuffInfo>;
      
      public function FightContainerBuff(param1:int)
      {
         this._buffs = new Vector.<FightBuffInfo>();
         super(param1);
         type = BuffType.Container;
      }
      
      public function addPayBuff(param1:FightBuffInfo) : void
      {
         this._buffs.push(param1);
      }
      
      public function get tipData() : Object
      {
         var _loc3_:BuffInfo = null;
         var _loc4_:FightBuffInfo = null;
         var _loc1_:BuffTipInfo = new BuffTipInfo();
         _loc1_.isActive = true;
         _loc1_.describe = LanguageMgr.GetTranslation("tank.view.buff.PayBuff.Note");
         _loc1_.name = LanguageMgr.GetTranslation("tank.view.buff.PayBuff.Name");
         _loc1_.isFree = false;
         var _loc2_:Vector.<BuffInfo> = new Vector.<BuffInfo>();
         for each(_loc4_ in this._buffs)
         {
            if(_loc4_.isSelf)
            {
               _loc3_ = PlayerManager.Instance.Self.getBuff(_loc4_.id);
               _loc3_.calculatePayBuffValidDay();
            }
            else
            {
               _loc3_ = new BuffInfo(_loc4_.id);
               _loc3_.day = _loc4_.data;
               _loc3_.isSelf = false;
            }
            _loc2_.push(_loc3_);
         }
         _loc1_.linkBuffs = _loc2_;
         return _loc1_;
      }
      
      public function dispose() : void
      {
         this._buffs.length = 0;
      }
   }
}
