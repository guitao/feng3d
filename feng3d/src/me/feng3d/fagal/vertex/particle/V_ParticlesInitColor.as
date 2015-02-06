package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalVertexMethod;

	/**
	 * 粒子颜色初始化
	 * @author warden_feng 2015-1-20
	 */
	public class V_ParticlesInitColor extends FagalVertexMethod
	{
		[Register(regName = "particleCommon_vc_vector", regType = "uniform", description = "粒子常数数据[0,1,2,0]")]
		public var particleCommon:Register;

		[Register(regName = "particleColorMultiplier_vt_4", regType = "out", description = "粒子颜色乘数因子，用于乘以纹理上的颜色值")]
		public var colorMulTarget:Register;

		[Register(regName = "particleColorOffset_vt_4", regType = "out", description = "粒子颜色偏移值，在片段渲染的最终颜色值上偏移")]
		public var colorAddTarget:Register;

		override public function runFunc():void
		{
			//初始化  粒子颜色乘数因子 为(1,1,1,1)
			mov(colorMulTarget, particleCommon.y);
			//初始化 粒子颜色偏移值 为(0,0,0,0)
			mov(colorAddTarget, particleCommon.x);
		}
	}
}