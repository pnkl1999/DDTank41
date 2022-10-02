package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.manager.LanguageMgr;
   import flash.geom.Point;
   import flash.text.TextFormat;
   
   public class MarriedTip extends OneLineTip
   {
       
      
      private var _nickNameTF:TextFormat;
      
      public function MarriedTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         _bg = ComponentFactory.Instance.creatComponentByStylename("core.MarriedTipBg");
         _contentTxt = ComponentFactory.Instance.creatComponentByStylename("core.commonTipText");
         this._nickNameTF = ComponentFactory.Instance.model.getSet("core.MarriedTipNickNameTF");
         addChild(_bg);
         addChild(_contentTxt);
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(param1 != _data)
         {
            _data = param1;
            _contentTxt.text = LanguageMgr.GetTranslation("core.MarriedTipLatterText" + String(!!Boolean(_data.gender) ? "Husband" : "Wife"),_data.nickName);
            _contentTxt.setTextFormat(this._nickNameTF,0,_contentTxt.length - 3);
            updateTransform();
         }
      }
      
      private function fitTextWidth() : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc1_:Point = localToGlobal(new Point(0,0));
         var _loc2_:int = _loc1_.x + width - 1000;
         if(_loc2_ > 0)
         {
            _loc3_ = _contentTxt.text;
            _contentTxt.text = _loc3_.substring(0,_loc3_.length - 3);
            _loc4_ = _contentTxt.getCharIndexAtPoint(_contentTxt.width - _loc2_ - 20,5);
            _contentTxt.text = _contentTxt.text.substring(0,_loc4_) + "..." + _loc3_.substr(_loc3_.length - 3);
         }
         _contentTxt.setTextFormat(this._nickNameTF,0,_contentTxt.length - 3);
         updateTransform();
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
         this.fitTextWidth();
      }
   }
}
