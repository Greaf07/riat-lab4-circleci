import pytest

from app import add, divide, multiply, subtract


def test_add_positive():
    assert add(2, 3) == 5


def test_add_negative():
    assert add(-4, -6) == -10


def test_add_different_signs():
    assert add(-1, 1) == 0


def test_add_zero():
    assert add(7, 0) == 7


def test_add_fractional():
    assert add(0.1, 0.2) == pytest.approx(0.3)


def test_subtract_positive():
    assert subtract(9, 4) == 5


def test_subtract_negative_result():
    assert subtract(3, 8) == -5


def test_subtract_equal():
    assert subtract(5, 5) == 0


def test_multiply_positive():
    assert multiply(6, 7) == 42


def test_multiply_negative():
    assert multiply(-3, 4) == -12


def test_multiply_zero():
    assert multiply(10, 0) == 0


def test_multiply_fractional():
    assert multiply(1.5, 2) == 3


def test_divide_positive():
    assert divide(10, 2) == 5


def test_divide_negative():
    assert divide(-9, 3) == -3


def test_divide_fractional():
    assert divide(1, 3) == pytest.approx(0.3333333333)


def test_divide_zero_numerator():
    assert divide(0, 5) == 0


def test_divide_by_zero():
    with pytest.raises(ValueError, match="На ноль делить нельзя"):
        divide(10, 0)


def test_divide_zero_by_zero():
    with pytest.raises(ValueError):
        divide(0, 0)
