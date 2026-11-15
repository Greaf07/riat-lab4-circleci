"""Простой калькулятор для проверки работы CircleCI."""


def add(a, b):
    return a + b


def subtract(a, b):
    return a - b


def multiply(a, b):
    return a * b


def divide(a, b):
    if b == 0:
        raise ValueError("На ноль делить нельзя.")
    return a / b


def main():
    while True:
        print("\nКалькулятор")
        print("1 — Сложение")
        print("2 — Вычитание")
        print("3 — Умножение")
        print("4 — Деление")
        print("0 — Выход")
        choice = input("Выберите действие: ").strip()

        if choice == "0":
            return
        if choice not in ("1", "2", "3", "4"):
            print("Введите номер от 0 до 4.")
            continue

        try:
            a = float(input("Первое число: ").replace(",", "."))
            b = float(input("Второе число: ").replace(",", "."))
        except ValueError:
            print("Ошибка: нужно ввести числа.")
            continue

        try:
            if choice == "1":
                result = add(a, b)
            elif choice == "2":
                result = subtract(a, b)
            elif choice == "3":
                result = multiply(a, b)
            else:
                result = divide(a, b)
            print(f"Результат: {result:g}")
        except ValueError as error:
            print(error)


if __name__ == "__main__":
    main()
