package ddt.view.buff.buffButton
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   import game.view.propertyWaterBuff.PropertyWaterBuffIcon;
   
   public class LabyrinthBuffItem extends Sprite implements Disposeable
   {
       
      
      private var _iconList:Vector.<PropertyWaterBuffIcon>;
      
      private var _buffDesc:Vector.<FilterFrameText>;
      
      public function LabyrinthBuffItem(param1:BuffInfo)
      {
         super();
         this._iconList = new Vector.<PropertyWaterBuffIcon>();
         this._buffDesc = new Vector.<FilterFrameText>();
         this.initView(param1);
      }
      
      private function initView(param1:BuffInfo) : void
      {
         var _loc3_:FilterFrameText = null;
         _loc3_ = null;
         var _loc2_:PropertyWaterBuffIcon = ComponentFactory.Instance.creat("game.view.propertyWaterBuff.propertyWaterBuffIcon",[param1]);
         this._iconList.push(_loc2_);
         addChild(_loc2_);
         _loc3_ = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.GesteField");
         var _loc4_:int = (_loc2_.tipData as BuffInfo).getLeftTimeByUnit(TimeManager.DAY_TICKS) * 24 * 60 + (_loc2_.tipData as BuffInfo).getLeftTimeByUnit(TimeManager.HOUR_TICKS) * 60 + (_loc2_.tipData as BuffInfo).getLeftTimeByUnit(TimeManager.Minute_TICKS);
         _loc3_.text = LanguageMgr.GetTranslation("game.view.propertyWaterBuff.timerII",_loc4_);
         _loc3_.x = _loc2_.x + 47;
         _loc3_.y = _loc2_.y + 7;
         this._buffDesc.push(_loc3_);
         addChild(_loc3_);
      }
      
      public function dispose() : void
      {
         var _loc1_:PropertyWaterBuffIcon = null;
         var _loc2_:FilterFrameText = null;
         for each(_loc1_ in this._iconList)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         for each(_loc2_ in this._buffDesc)
         {
            ObjectUtils.disposeObject(_loc2_);
            _loc2_ = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
