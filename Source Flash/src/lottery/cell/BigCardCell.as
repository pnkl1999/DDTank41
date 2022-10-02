package lottery.cell
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class BigCardCell extends SmallCardCell
   {
       
      
      private var _bg:Bitmap;
      
      private var _nameField:FilterFrameText;
      
      private var _shading:Bitmap;
      
      private var _isShowName:Boolean = true;
      
      public function BigCardCell()
      {
         super();
      }
      
      public function get isShowName() : Boolean
      {
         return this._isShowName;
      }
      
      public function set isShowName(param1:Boolean) : void
      {
         this._isShowName = param1;
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._nameField = ComponentFactory.Instance.creatComponentByStylename("lottery.lotteryCardCell.nameField");
         addChild(this._nameField);
         _selectedBg.setFrame(2);
         ShowTipManager.Instance.removeTip(this);
         addEventListener(MouseEvent.CLICK,this.__cellClick);
      }
      
      override protected function updateSize() : void
      {
         var _loc1_:Rectangle = null;
         _loc1_ = null;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("lottery.cardCell.picBigSize");
         _pic.width = _loc1_.width;
         _pic.height = _loc1_.height;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("lottery.cardCell.selectedBigSize");
         _selectedBg.width = _loc1_.width;
         _selectedBg.height = _loc1_.height;
         _selectedBg.x = _loc1_.x;
         _selectedBg.y = _loc1_.y;
      }
      
      override public function set cardId(param1:int) : void
      {
         super.cardId = param1;
         this._nameField.text = String(_tipData);
         this._nameField.visible = this.isShowName;
      }
      
      private function __cellClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__cellClick);
         if(this._nameField)
         {
            ObjectUtils.disposeObject(this._nameField);
         }
         this._nameField = null;
         super.dispose();
      }
   }
}
