class X2Effect_SharkyShark extends X2Effect_Persistent;

const K = 2.11f;
const A = 0.035f;
const B = -2.275f;
const C = 0.01f;
const e = 2.7182818284f;

protected function float GetConfusingScalingValue(float x)
{
    return 1.0f + K
        + K * (Exp(2 * (A * x + B)) - 1)
            / ((Exp(2 * (A * x + B)) + 1))
        + (Exp(2 * C * x) - 1)
            / (2 * Exp(C * x));
}