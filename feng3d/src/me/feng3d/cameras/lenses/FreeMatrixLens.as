package me.feng3d.cameras.lenses
{

	/**
	 *
	 * @author warden_feng 2015-5-28
	 */
	public class FreeMatrixLens extends LensBase
	{
		public function FreeMatrixLens()
		{
			super();
		}

		override protected function updateMatrix():void
		{
			_matrixInvalid = false;
		}
	}
}
